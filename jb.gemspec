# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jb/version'

Gem::Specification.new do |spec|
  spec.name          = "jb"
  spec.version       = Jb::VERSION
  spec.authors       = ["Akira Matsuda"]
  spec.email         = ["ronnie@dio.jp"]

  spec.summary       = 'Faster and simpler Jbuilder alternative'
  spec.description   = 'Faster and simpler Jbuilder alternative'
  spec.homepage      = 'https://github.com/amatsuda/jb'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'test-unit-rails'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'capybara'
end
