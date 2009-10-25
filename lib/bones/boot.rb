require 'rubygems'
require 'activesupport'
require 'rack'
require 'pathname'
require Pathname.new(__FILE__).dirname.join('bones.rb')
require Pathname.new(__FILE__).dirname.join('extensions.rb')

ActiveSupport::Dependencies.load_paths.push Bones.system_path
$:.push Bones.system_path

require 'yaml'
require 'fileutils'
require 'optparse'
require 'ostruct'
require 'erb'

Bones.booted = true

def directories(base)
  Dir.chdir(base) do
    Dir.entries(base).map do |e|
      next if e =~ /^\.+$/ 
      File.directory?(base / e) ? '/' + e : nil
    end.compact
  end
end

def page_directories
  directories(Bones.root / 'pages')
end

def versioned_directories
  Bones::VersionedRelease.directories
end

def public_directories
  directories(Bones.root / 'public') - page_directories - versioned_directories
end