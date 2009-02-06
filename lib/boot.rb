require 'rubygems'
require 'activesupport'

require File.join(File.dirname(__FILE__), 'bones.rb')
require File.join(File.dirname(__FILE__), 'extensions.rb')

# Bones.root = BONES_ROOT if Object.const_defined?(:BONES_ROOT)
ActiveSupport::Dependencies.load_paths.push << Bones.system_path

require 'yaml'
require 'rack'
require 'rack/request'
require 'rack/response'

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