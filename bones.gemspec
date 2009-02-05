Gem::Specification.new do |s|
  s.name        = "bones"
  s.version     = "0.1.5"
  s.date        = "2009-02-04"
  s.authors     = ["Chris Scharf", "Ryan Heath"]
  s.email       = "scharfie@gmail.com"

  s.summary     = "Simple HTML mockup framework for designers using ERB"
  s.description = "Simple HTML mockup framework for designers using ERB"
  s.homepage    = "http://github.com/scharfie/bones"
  
  s.has_rdoc    = false
	
  s.require_paths      = ['lib']	
  s.default_executable = 'bones'
  s.executables        = ['bones']
  
  s.files = [ 
    'README',
    'lib/Rakefile',
    'bin/bones',
    'lib/bones.rb',
    'lib/bones/release.rb',
    'lib/boot.rb',
    'lib/cache.rb',
    'lib/extensions.rb',
    'lib/helpers',
    'lib/helpers/core_helper.rb',
    'lib/init.rb',
    'lib/pages/directory.html.erb',
    'lib/pages/intro.html.erb',
    'lib/server.rb',
    'lib/tasks/bones.rb',
    'bones.gemspec'
  ]

  # Dependencies
  s.add_dependency("rack", ["= 0.3.0"])
  s.add_dependency("activesupport", [">= 2.1.0"])
end
