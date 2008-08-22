Gem::Specification.new do |s|
  s.name     = "bones"
  s.version  = "0.1.0"
  s.date     = "2008-08-22"
  s.summary  = ""
  s.email    = "scharfie@gmail.com"
  s.homepage = "http://github.com/scharfie/bones"
  s.description = ""
  s.has_rdoc = true
  s.authors  = ["Chris Scharf", "Ryan Heath"]
  s.files    = [
    'lib/bones/bones.rb'
	]
  # s.rdoc_options = ["--main", "README.txt"]
  # s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  
  s.add_dependency("rack", [">= 0.3.0"])
  s.add_dependency("activesupport", [">= 2.1.0"])
end
