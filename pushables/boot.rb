bones_boot = File.join(File.dirname(__FILE__), 'bones', 'lib', 'boot.rb')

if File.file?(bones_boot)
  require bones_boot
else
  require 'rubygems'
  require 'bones'
  require 'boot'
end
  
Bones.root = File.expand_path(File.dirname(__FILE__))