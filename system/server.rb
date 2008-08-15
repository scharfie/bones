require File.join(File.dirname(__FILE__), 'boot')
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

port = ARGV.shift || 3000
puts "** Starting bones server on http://0.0.0.0:#{port}"
Rack::Handler::Mongrel.run app, :Port => port do |server|
  puts "** Use CTRL-C to stop."
end