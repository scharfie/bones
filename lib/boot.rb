SYSTEM  = File.dirname(__FILE__)
ROOT    = File.expand_path('.') unless Object.const_defined?(:ROOT)
PAGES   = File.join(ROOT, 'pages')
LAYOUTS = File.join(ROOT, 'layouts')

$:.unshift(SYSTEM)
$:.unshift(File.join(ROOT, 'lib'))

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

def directories(base)
  Dir.chdir(base) do
    Dir.entries(base).map do |e|
      next if e =~ /^\.+$/ 
      File.directory?(base / e) ? '/' + e : nil
    end.compact
  end  
end

def page_directories
  directories(ROOT / 'pages')
end

def versioned_directories
  Bones::VersionedRelease.directories
end

def public_directories
  directories(ROOT / 'public') - page_directories - versioned_directories
end