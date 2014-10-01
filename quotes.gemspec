# coding: utf-8
$:.unshift File.expand_path('../lib', __FILE__)
require 'quotes/version'

Gem::Specification.new do |spec|
  spec.name          = "quotes"
  spec.version       = Quotes::VERSION
  spec.authors       = ["Ben Toews"]
  spec.email         = ["mastahyeti@gmail.com"]
  spec.summary       = %q{Ruby method call finder}

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["quotes"]
  spec.require_paths = ["lib"]

  spec.add_dependency "parser", "~> 2.1.9"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
