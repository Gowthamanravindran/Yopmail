Gem::Specification.new do |s|
  s.name        = 'Yopmail'
  s.version     = '1.0'
  s.summary     = 'Yopmail Helper using API'
  s.description = 'Yopmail Assistant - fetch mail and mail content using API calls'
  s.authors     = ["Gowthaman"]
  s.email       = ['gowthaman.work@gmail.com']
  s.files       = Dir["lib/*.rb", "lib/**/*.rb", "bin/yopmail"]
  # s.files       = `git ls-files`.split("\n")
  s.bindir      = 'bin'
  s.executables = 'yopmail'
  s.homepage    = 'https://rubygems.org/gems/example'
  s.metadata    = { "source_code_uri" => "https://github.com/Gowthamanravindran/Yopmail.git" }
  s.license       = 'MIT'
end
