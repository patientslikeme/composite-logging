# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'composite_logging/version'

Gem::Specification.new do |spec|
  spec.name          = "composite_logging"
  spec.version       = CompositeLogging::VERSION
  spec.authors       = ["Michael Deutsch"]
  spec.email         = ["mdeutsch@patientslikeme.com"]
  spec.summary       = "Log to multiple destinations with the Ruby logger."
  spec.description   = "Log to multiple destinations with the Ruby logger."
  spec.homepage      = "http://github.com/patientslikeme/composite_logging"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ansi", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "gemfury", ">= 0.4.26"
end
