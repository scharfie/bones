vendor_bones = File.join(File.dirname(__FILE__), 'vendor/bones/lib/bones.rb')

if File.file?(vendor_bones)
  require vendor_bones
else
  require 'rubygems'
  require 'bones'
end
  
Bones.root = File.expand_path(File.dirname(__FILE__))
