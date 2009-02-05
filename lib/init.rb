require File.join(File.dirname(__FILE__), 'boot') if __FILE__ == $0
require 'fileutils'

class BonesInitializer
  def self.ensure_file(path, &block)
    return if File.exist?(path)
    puts "** Writing #{path}"
    File.open(path, 'w', &block)
  end

  def self.ensure_directory(path)
    return nil if File.directory?(path)
    puts "** Creating directory #{path}"
    FileUtils.mkdir_p(path)  
    return true
  end

  def self.run
    puts "** Initializing"

    ensure_directory(Bones.root / 'public' / 'javascripts')
    ensure_directory(Bones.root / 'public' / 'stylesheets')
    pages_new = ensure_directory(Bones.root / 'pages')
    ensure_directory(Bones.root / 'layouts')
    ensure_directory(Bones.root / 'helpers')

    if pages_new
      ensure_file(Bones.root / 'pages' / 'index.html.erb') do |f|
        f.write File.read(Bones.system_path / 'pages' / 'intro.html.erb')
      end
    end  

    ensure_file(Bones.root / 'layouts' / 'application.html.erb') do |f|
      f.write <<-HTML
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html>
    <head>
      <meta http-equiv="Content-type" content="text/html; charset=utf-8">
      <title>Welcome to bones</title>
      <%= stylesheet_link_tag 'styles' %>
      <%= javascript_include_tag %>
    </head>  
    <body>
      <h1>Welcome to <strong>bones</strong></h1>
      <%= @content_for_layout %>
    </body>
    </html>  
      HTML
    end

    ensure_file(Bones.root / 'public' / 'stylesheets' / 'styles.css')

    ensure_file(Bones.root / 'Rakefile') do |f|
      puts "** Adding Rakefile to parent directory"
      f.write File.read(Bones.system_path / 'Rakefile')
    end

    puts <<-HELP if __FILE__ == $0

     All set! Now just run:
       ruby bones/server.rb
 
     The app will run on port 3000
 
    HELP
  end
end

BonesInitializer.run if __FILE__ == $0