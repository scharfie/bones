class Bones
  class Server
    def self.run
      statics = Bones.public_directories
      app = Rack::Builder.new do
        use Rack::CommonLogger
        use Rack::ShowExceptions
        use Rack::Reloader
        use Bones::Static
        run Bones::Proxy.new
      end
    
      port = ARGV.shift || 3000
      puts "** Starting bones server on http://0.0.0.0:#{port}"
      puts "** Public directories: #{statics.to_sentence}"
    
      Rack::Handler::Mongrel.run app, :Port => port do |server|
        puts "** Use CTRL-C to stop."
      end
    end
  end  
end

Bones::Server.run if __FILE__ == $0
