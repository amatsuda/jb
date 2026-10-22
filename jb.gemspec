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

  spec.files         = `git ls-files -z -- lib LICENSE.txt README.md`.split("\x0")
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency 'railties', '>= 4.2'
  spec.add_dependency 'actionview', '>= 4.2'
end
