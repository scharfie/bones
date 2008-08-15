SYSTEM  = File.dirname(__FILE__)
ROOT    = File.expand_path(SYSTEM + '/../')
PAGES   = File.join(ROOT, 'pages')
LAYOUTS = File.join(ROOT, 'layouts')

$:.unshift(SYSTEM)

require 'yaml'
require 'rack'
require 'rack/request'
require 'rack/response'
require 'activesupport'
require 'extensions'
require 'erb'
require 'init'

# ApplicationProxy is simply a proxy class handler
# to the actual Application class - the reason for 
# this is to allow live changes to the Application
# and helpers, etc.  The proxy reloads on every 
# request
class ApplicationProxy
  def call(env)
    reload!
    Application.new.call(env)  
  end
  
  def reload!
    Class.remove_class('Application') if Object.const_defined?('Application')
    load 'application.rb'    
  end
end

def public_directories
  Dir.chdir(base = ROOT / 'public') do
    Dir.entries(base).map do |e|
      next if e =~ /^\.+$/ 
      File.directory?(base / e) ? '/' + e : nil
    end.compact
  end  
end  

app = Rack::Builder.new do
   use Rack::CommonLogger
   use Rack::ShowExceptions
   use Rack::Reloader
   use Rack::Static, :urls => public_directories, :root => 'public'
   run ApplicationProxy.new
end

puts ">> Starting server"
Rack::Handler::Mongrel.run app, :Port => (ARGV.shift || 3000)