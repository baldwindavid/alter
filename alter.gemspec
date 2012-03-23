# -*- encoding: utf-8 -*-
require File.expand_path('../lib/alter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Baldwin"]
  gem.email         = ["baldwindavid@gmail.com"]
  gem.description   = %q{Enforce structure by moving content filters to easy-to-write processor classes}
  gem.summary       = %q{Alter enforces structure by moving content filters to easy-to-write processor classes}
  gem.homepage      = ""
  
  gem.add_development_dependency "rspec"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "alter"
  gem.require_paths = ["lib"]
  gem.version       = Alter::VERSION
end