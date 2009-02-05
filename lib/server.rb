#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'boot')
require 'init'

# BonesProxy is simply a proxy class handler
# to the actual Bones class - the reason for 
# this is to allow live changes to Bones
# and helpers, etc.  The proxy reloads on every 
# request
class BonesProxy
  # Process incoming request
  def call(env)
    reload!
    Bones.new.call(env)  
  end
  
  # Reloads the application
  def reload!
    force_load 'Bones' => 'bones.rb'
  end
end

class BonesServer
  def self.run
    statics = public_directories
    
    app = Rack::Builder.new do
       use Rack::CommonLogger
       use Rack::ShowExceptions
       use Rack::Reloader
       use Rack::Static, :urls => statics, :root => ROOT / 'public'
       run BonesProxy.new
    end

    port = ARGV.shift || 3000
    puts "** Starting bones server on http://0.0.0.0:#{port}"
    puts "** Public directories: #{statics.to_sentence}"
    Rack::Handler::Mongrel.run app, :Port => port do |server|
      puts "** Use CTRL-C to stop."
    end
  end
end

BonesServer.run if __FILE__ == $0