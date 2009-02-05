#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'boot')
require 'fileutils'
require 'optparse'
require 'ostruct'

class Bones
  class Cache
    class Options
      attr_accessor :base, :versioned, :release, :destination, :noop
      
      def initialize
        super
        self.base        = ''               # Base URL is empty
        self.release     = nil
        self.noop        = false
      end
      
      def merge(options={})
        options.each do |k, v|
          method = "#{k}=".to_sym
          send(method, v) if respond_to?(method)
        end
      end
  
      # Process arguments
      def self.process(args)
        options = new
    
        OptionParser.new do |o|
          o.on('--destination PATH', '-d PATH', "Change the destination directory") do |path|
            options.destination = path
          end
      
          o.on('--versioned', '--versions', "Enable versioning") do
            options.versioned = true
          end
      
          o.on('--base PATH', "Change the base URL path") do |path|
            options.base = path # Bones.base = path
          end
          
          o.on('--noop', "Do not write any files") do
            options.noop = true
          end
      
          o.on_tail("-h", "--help", "Show this message") do
            puts o; exit
          end
        end.parse!(args)
    
        options
      end
      
      def base=(path)
        @base = Bones.base = path
      end
      
      def versioned=(*args)
        @release = Bones::VersionedRelease.new(@destination)
        @destination = release.destination
      end
      
      def destination=(path)
        if File.expand_path(path) == default_destination
          @release = nil
          @destination = default_destination
        else  
          @release = Bones::Release.new(@destination, path)
          @destination = release.destination
        end  
      end
      
      def default_destination
        File.expand_path(ROOT / 'public')
      end
  
      # Returns true if the versions enabled
      def versioned?
        Bones::VersionedRelease === release
      end
  
      def release?
        !release.nil?
      end
  
      # Returns destination
      def destination
        return release.destination if release?
        @destination ||= default_destination
      end
    end
    
    attr_accessor :options
    
    def initialize(options=nil)
      self.options = Options === options ? options : Options.process(options)
    end
    
    def self.run(options=nil)
      new(options).run
    end

    def run
      version = options.versioned? ? options.release.versioned_directory_name : nil
      
      # Process each page
      Dir.chdir(ROOT) do
        puts "** Note: No files/directories will be modified (noop flag)" if options.noop        
        puts "** Writing to: #{options.destination}"
        puts "** Using base: #{options.base}" unless options.base.blank?
        
        pages = Bones.pages
        total = pages.length
        pages.each_with_index do |page, index|
          print  "\r     %-70s (%4d/%4d)" % [[version, page].compact.join('/') + '.html', index + 1, total]
          $stdout.flush
          template = Bones::Template.new(page)
          template.request = generate_mock_request(:path_info => page)
          result = template.compile
          result.gsub!(/(href|src|action|url)(="|\()([-A-Za-z0-9_\.\/]+)([^:]*?)("|\))/) do |match|
            property, url, params = $1, normalize_url(original_url = $3, options.base), $4
            property =~ /url/ ? 'url(%s%s)' % [url, params] : '%s="%s%s"' % [property, url, params]
          end
          path = options.destination / page + '.html'
          
          unless options.noop
            FileUtils.mkdir_p(File.dirname(path))
            File.open(path, 'w') { |f| f.write(result) }
          end  
        end
        
        puts "\n"

        if options.release?  
          puts "** Copying public files"
          options.release.copy_public_directories unless options.noop
        end
  
        # puts "** Cached to: #{options.destination}" 
        # puts "** Using base: #{options.base}" unless options.base.blank?
        # puts "** Note: No files/directories were modified (noop flag)" if options.noop
      end

      puts "** Done."      
    end
    
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
        when path =~ /^(\w{3,}:\/\/|mailto)/
          return path
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

    def generate_mock_request(options={})
      OpenStruct.new(options)
    end
  end
end

if __FILE__ == $0
  Bones::Cache.run(ARGV)
end