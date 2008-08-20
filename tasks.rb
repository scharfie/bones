desc "Start bones server"
task :server do
  ARGV.shift
  load File.join(File.dirname(__FILE__), 'server.rb')
end

desc "Cache page templates for redistribution"
task :cache do
  ARGV.shift
  load File.join(File.dirname(__FILE__), 'cache.rb')
end

task :clean do
  # TODO
  # ARGV.shift
  # ARGV.unshift '--clean'
  # load File.join(File.dirname(__FILE__), 'cache.rb')
end