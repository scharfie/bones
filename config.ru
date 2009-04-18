require File.join(File.dirname(__FILE__), 'boot.rb')
use Rack::CommonLogger
use Rack::ShowExceptions
use Rack::Reloader
use Bones::Static
run Bones::Proxy.new