SYSTEM  = File.dirname(__FILE__)
ROOT    = File.expand_path(SYSTEM + '/../')
PAGES   = File.join(ROOT, 'pages')
LAYOUTS = File.join(ROOT, 'layouts')

$:.unshift(SYSTEM)

require 'rubygems'
require 'yaml'
require 'rack'
require 'rack/request'
require 'rack/response'
require 'activesupport'
require 'extensions'
require 'erb'

def public_directories
  Dir.chdir(base = ROOT / 'public') do
    Dir.entries(base).map do |e|
      next if e =~ /^\.+$/ 
      File.directory?(base / e) ? '/' + e : nil
    end.compact
  end  
end