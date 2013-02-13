Gem::Specification.new do |s|
  s.name          = "cinch-authentication"
  s.version       = '0.1.0'
  s.authors       = ["Paul Brickfeld"]
  s.email         = ["paulbrickfeld@gmail.com"]
  s.homepage      = "https://github.com/britishtea/cinch-authentication"
  s.summary       = "Authentication for Cinch."
  s.description   = "An authentication system with multiple strategies for " + 
    "the Cinch IRC framework."

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'cinch', '~> 2.0.3'
end
