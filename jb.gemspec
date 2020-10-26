# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jb/version'

Gem::Specification.new do |spec|
  spec.name          = "jb"
  spec.version       = Jb::VERSION
  spec.authors       = ["Akira Matsuda"]
  spec.email         = ["ronnie@dio.jp"]

  spec.summary       = 'Faster and simpler Jbuilder alternative'
  spec.description   = 'Faster and simpler JSON renderer for Rails'
  spec.homepage      = 'https://github.com/amatsuda/jb'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'test-unit-rails'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'action_args'
  spec.add_development_dependency 'byebug'
end
