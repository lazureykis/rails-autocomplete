# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/autocomplete/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-autocomplete"
  spec.version       = Rails::Autocomplete::VERSION
  spec.authors       = ["Pavel Lazureykis"]
  spec.email         = ["lazureykis@gmail.com"]

  spec.summary       = %q{Fast autocomplete solution for Ruby on Rails.}
  spec.description   = %q{Autocomplete rack engine which uses redis as backend.}
  spec.homepage      = "https://github.com/lazureykis/rails-autocomplete"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.platform = Gem::Platform::RUBY

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard"
  spec.add_runtime_dependency "redis", "~> 3.2"
  spec.add_runtime_dependency "hiredis", "~> 0.6"
end
