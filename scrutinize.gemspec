# coding: utf-8
$:.unshift File.expand_path('../lib', __FILE__)
require 'scrutinize/version'

Gem::Specification.new do |spec|
  spec.name          = "scrutinize"
  spec.version       = Scrutinize::VERSION
  spec.authors       = ["Ben Toews"]
  spec.email         = ["mastahyeti@gmail.com"]
  spec.summary       = %q{Ruby method call finder}

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["scrutinize"]
  spec.require_paths = ["lib"]

  spec.add_dependency "parser", "~> 2.4.0"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
