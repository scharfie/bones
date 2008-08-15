unless Object.const_defined?(:SYSTEM)
  SYSTEM  = File.dirname(__FILE__) 
  ROOT    = File.expand_path(SYSTEM + '/../')
  $:.unshift(SYSTEM)
end  

require 'extensions'
require 'fileutils'

def ensure_file(path, &block)
  return if File.exist?(path)
  puts ">> Writing #{path}"
  File.open(path, 'w', &block)
end

def ensure_directory(path)
  return if File.directory?(path)
  puts ">> Creating directory #{path}"
  FileUtils.mkdir_p(path)  
end

puts ">> Initializing"

ensure_directory(ROOT / 'public' / 'javascripts')
ensure_directory(ROOT / 'public' / 'stylesheets')
ensure_directory(ROOT / 'pages')
ensure_directory(ROOT / 'layouts')
ensure_directory(ROOT / 'helpers')

ensure_file(ROOT / 'layouts' / 'application.html.erb') do |f|
  f.write <<-HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
  <meta http-equiv="Content-type" content="text/html; charset=utf-8">
  <title>TITLE</title>
  <%= stylesheet_link_tag 'styles' %>
  <%= javascript_include_tag %>
</head>  
<body>
  <h1>Hello</h1>
  <%= @content_for_layout %>
  <%= partial 'footer' %>
</body>
</html>  
  HTML
end

ensure_file(ROOT / 'public' / 'stylesheets' / 'styles.css')

puts <<-HELP if __FILE__ == $0

 All set! Now just run:
   ruby vendor/server.rb
 
 The app will run on port 3000
 
HELP