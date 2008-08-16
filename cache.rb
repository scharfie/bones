#!/usr/bin/ruby
require File.join(File.dirname(__FILE__), 'boot')
require 'fileutils'
require 'bones'

# Set destination
destination = ROOT / 'public'

# Process each page
Bones.pages.each do |page|
  puts  "** Generating #{page}.html"
  result = Bones::Template.compile(page)
  path   = destination / page + '.html'
  FileUtils.mkdir_p(File.dirname(path))
  File.open(path, 'w') { |f| f.write(result) }
end

puts "** Done."