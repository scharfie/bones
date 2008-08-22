Gem::Specification.new do |s|
  s.name     = "bones"
  s.version  = "0.1.1"
  s.date     = "2008-08-22"
  s.summary  = "Simple HTML mockup framework for designers using ERB"
  s.email    = "scharfie@gmail.com"
  s.homepage = "http://github.com/scharfie/bones"
  s.description = s.summary
  s.has_rdoc = false
  s.authors  = ["Chris Scharf", "Ryan Heath"]
	
  s.require_paths = ["lib"]	
  s.default_executable = "bones"
  s.executables        = %W(bones)
  
  s.add_dependency("rack", [">= 0.3.0"])
  s.add_dependency("activesupport", [">= 2.1.0"])

  s.files = [ 
    'README',
    'bin/bones',
    'lib/bones.rb',
    'lib/boot.rb',
    'lib/cache.rb',
    'lib/extensions.rb',
    'lib/helpers',
    'lib/helpers/core_helper.rb',
    'lib/init.rb',
    'lib/pages/directory.html.erb',
    'lib/pages/intro.html.erb',
    'lib/Rakefile',
    'lib/server.rb',
    'lib/tasks/bones.rb'
  ]
end
