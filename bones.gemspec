Gem::Specification.new do |s|
  s.name        = "bones"
  s.version     = "0.2.1"
  s.date        = "2009-02-10"
  s.authors     = ["Chris Scharf", "Ryan Heath"]
  s.email       = "scharfie@gmail.com"

  s.summary     = "Simple HTML mockup framework for designers using ERB"
  s.description = "Simple HTML mockup framework for designers using ERB"
  s.homepage    = "http://github.com/scharfie/bones"
  
  s.has_rdoc    = false
	
  s.require_paths      = ['lib']	
  s.executables        = ['bones']
  s.default_executable = 'bones'
  
  s.files = [ 
    'bin',
    'bin/bones',
    'bones.gemspec',
    'lib/bones',
    'lib/bones/cache.rb',
    'lib/bones/initializer.rb',
    'lib/bones/release.rb',
    'lib/bones/template.rb',
    'lib/bones/versioned_release.rb',
    'lib/bones.rb',
    'lib/boot.rb',
    'lib/extensions.rb',
    'lib/helpers',
    'lib/helpers/core_helper.rb',
    'lib/pages/directory.html.erb',
    'lib/pages/intro.html.erb',
    'lib/Rakefile',
    'lib/server.rb',
    'lib/tasks',
    'lib/tasks/bones.rb',
    'Rakefile',
    'README',
    'test',
    'test/example_site',
    'test/example_site/helpers',
    'test/example_site/helpers/custom_helper.rb',
    'test/example_site/layouts',
    'test/example_site/layouts/example_layout.html.erb',
    'test/example_site/pages',
    'test/example_site/pages/about.html.erb',
    'test/example_site/pages/index.html.erb',
    'test/example_site/pages/partials',
    'test/example_site/pages/partials/_footer.html.erb',
    'test/example_site/pages/things',
    'test/example_site/pages/things/a.html.erb',
    'test/example_site/public',
    'test/example_site/public/images',
    'test/example_site/public/images/.gitignore',
    'test/example_site/public/javascripts',
    'test/example_site/public/javascripts/.gitignore',
    'test/example_site/public/stylesheets',
    'test/example_site/public/stylesheets/.gitignore',
    'test/example_site/public/videos',
    'test/example_site/public/videos/.gitignore',
    'test/test_bones.rb',
    'test/test_cache.rb',
    'test/test_template.rb',
    'test/test_example_site.rb',
    'test/test_helper.rb'
  ]

  # Dependencies
  s.add_dependency("rack", ["= 0.3.0"])
  s.add_dependency("activesupport", [">= 2.1.0"])
end