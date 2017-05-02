# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cru_lib/version'

Gem::Specification.new do |spec|
  spec.name          = 'cru_lib'
  spec.version       = CruLib::VERSION
  spec.authors       = ['Josh Starcher']
  spec.email         = ['josh.starcher@gmail.com']
  spec.summary       = 'Misc libraries for Cru'
  spec.description   = 'Collection of common ruby logic used by a number of Cru apps'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'global_registry', '~> 1.0'

  spec.add_runtime_dependency 'rails', '>= 4.2.0'
  spec.add_runtime_dependency 'activesupport', '>= 4.2.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
end
