# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pipeline/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nikita B. Zuev"]
  gem.email         = ["nikitazu@gmail.com"]
  gem.description   = %q{A bunch of pipes to connect, and perform some jobs}
  gem.summary       = %q{Loading files, archiving, emailing them...}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pipeline"
  gem.require_paths = ["lib"]
  gem.version       = Pipeline::VERSION
  
  # unit testing
  gem.add_development_dependency 'rspec', "~> 2.6"
  
  # testing cli
  gem.add_development_dependency "cucumber"
  gem.add_development_dependency "aruba"
  
  # zip+split not working correctly
  gem.add_dependency 'rubyzip', "0.9.9"
  
  # cli
  gem.add_dependency 'thor'
end
