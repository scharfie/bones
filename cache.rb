#!/usr/bin/ruby
require File.join(File.dirname(__FILE__), 'boot')
require 'fileutils'
require 'bones'

# Set destination
destination = ROOT / 'public'

# Set the base URL from first argument
base = ARGV.shift || ''

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
    else
      path + '.html'
    end
    
    @known_pairs[path] = base / value
  end    
end

# Process each page
Dir.chdir(ROOT) do
  Bones.pages.each do |page|
    puts  "** Generating #{page}.html"
    result = Bones::Template.compile(page)
    result.gsub!(/(href|src|action)="([-A-Za-z0-9_\.\/]+)(.*?)"/) do |match|
      property, url, params = $1, normalize_url(original_url = $2, base), $3
      # puts "%40s => %40s" % [original_url, url]
      '%s="%s%s"' % [property, url, params]
    end
  
    path   = destination / page + '.html'
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, 'w') { |f| f.write(result) }
  end
end

puts "** Done."