require File.join(File.dirname(__FILE__), '..', 'cache.rb')

task :default => :server

desc "Start bones server"
task :server do
  ARGV.shift
  load File.join(File.dirname(__FILE__), '..', 'server.rb')
  BonesServer.run
end

desc "Cache page templates for redistribution (non-versioned)"
task :cache => 'cache:simple'

namespace :cache do
  def destination_from_environment
    %w(DESTINATION DEST).each do |k|
      return ENV[k] unless ENV[k].blank?
    end  
  end
  
  def generate_options_from_environment(extra={})
    returning Bones::Cache::Options.new do |options|
      destination = destination_from_environment
      options.base = ENV['BASE'] unless ENV['BASE'].blank?
      options.destination = destination unless destination.blank?
      options.merge extra
    end  
  end
  
  task :simple do
    options = generate_options_from_environment
    Bones::Cache.run(options)
  end
  
  desc "Cache page templatets for redistribution (versioned)"
  task :versioned do
    options = generate_options_from_environment(:versioned => true)
    Bones::Cache.run(options)
  end
end

task :clean do
  # TODO
  # ARGV.shift
  # ARGV.unshift '--clean'
  # load File.join(File.dirname(__FILE__), 'cache.rb')
end