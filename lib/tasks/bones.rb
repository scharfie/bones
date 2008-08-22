desc "Start bones server"
task :server do
  ARGV.shift
  load File.join(File.dirname(__FILE__), '..', 'server.rb')
  BonesServer.run
end

namespace :cache do
  desc "Cache page templates for redistribution (non-versioned)"
  task :simple do
    ARGV.shift
    load File.join(File.dirname(__FILE__), '..', 'cache.rb')
  end
  
  desc "Cache page templatets for redistribution (versioned)"
  task :versioned do
    ARGV.shift
    file = File.join(File.dirname(__FILE__), '..', 'cache.rb')
    system "ruby #{file} '--versioned'"
  end
end

task :clean do
  # TODO
  # ARGV.shift
  # ARGV.unshift '--clean'
  # load File.join(File.dirname(__FILE__), 'cache.rb')
end