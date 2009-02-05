require File.join(File.dirname(__FILE__), 'bones.rb')

Bones.root = BONES_ROOT if Object.const_defined?(:BONES_ROOT)

$:.unshift(Bones.system_path)
$:.unshift(File.join(Bones.root, 'lib'))

require 'rubygems'
require 'yaml'
require 'rack'
require 'rack/request'
require 'rack/response'
require 'activesupport'
require 'extensions'
require 'erb'
require 'bones'
require 'bones/release'
require 'bones/template'

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