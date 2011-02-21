vendor_bones = File.join(File.dirname(__FILE__), 'vendor/bones/lib/bones.rb')

if File.file?(vendor_bones)
  require vendor_bones
else
  require 'rubygems'
  gem      'scharfie-bones', '0.2.7'
  require 'bones'
end
  
Bones.root = File.expand_path(File.dirname(__FILE__))
