#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'boot')
require 'fileutils'
require 'bones'
require 'optparse'
require 'ostruct'

# Argument processor
class CacheOptions < OpenStruct
  # Default options
  def self.default_options
    returning new do |o|
      o.destination = ROOT / 'public'  # Set original destination
      o.versioned   = false            # No versions by default       
      o.base        = ''               # Base URL is empty
    end
  end
  
  # Process arguments
  def self.process(args)
    options = default_options
    
    OptionParser.new do |o|
      o.on('--versioned', '--versions', "Enable versioning") do
        options.versioned   = Bones::Versioned.new(options.destination)
      end
      
      o.on('--base PATH', "Change the base URL path") do |path|
        options.base = path
      end

      o.on_tail("-h", "--help", "Show this message") do
        puts o
        exit
      end
    end.parse!(args)
    
    options
  end
  
  # Returns true if the versions enabled
  def versioned?
    versioned != false
  end
  
  # Returns destination
  def destination
    versioned? ?  versioned.destination : super
  end
end

# Process arguments
options = CacheOptions.process(ARGV)

# Fixes the given URL path to begin at given base.
# In addition, the .html extension will be added if
# the path is a page.
# 
# For example, if the base is /some_folder,
#   normalize_url('/page_path', '/some_folder')
#   # => /some_folder/page_path.html
def normalize_url(path, base='')
  @known_pairs ||= {}
  @public_directories_regex ||= Regexp.new(public_directories.join('|'))
  
  if v = @known_pairs[path]
    return v
  else
    value = case
    when path =~ @public_directories_regex
      path
    when File.directory?('pages' / path)
      path
    when path =~ /^mailto/
      return path  
    else
      path + '.html'
    end
    
    @known_pairs[path] = base / value
  end    
end

def generate_mock_request(options={})
  OpenStruct.new(options)
end

version = options.versioned? ? options.versioned.versioned_directory_name : nil

# Process each page
Dir.chdir(ROOT) do
  Bones.pages.each do |page|
    puts  "** Generating #{[version, page].compact.join('/')}.html"
    template = Bones::Template.new(page)
    template.request = generate_mock_request(:path_info => page)
    result = template.compile
    result.gsub!(/(href|src|action)="([-A-Za-z0-9_\.\/]+)(.*?)"/) do |match|
      property, url, params = $1, normalize_url(original_url = $2, options.base), $3
      '%s="%s%s"' % [property, url, params]
    end
  
    path = options.destination / page + '.html'
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, 'w') { |f| f.write(result) }
  end

  if options.versioned?  
    puts "** Copying public files"
    options.versioned.copy_public_directories
  end  
end

puts "** Done."