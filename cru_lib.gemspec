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
  spec.summary       = 'Map ActiveRecord to Global Registry'
  spec.description   = 'Provides a common interface for mapping ActiveRecord ' \
                       'models to Global Registry entities and relationships.'
  spec.homepage      = 'https://github.com/CruGlobal/cru_lib'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'global_registry', '~> 1.0'

  spec.add_runtime_dependency 'rails', '>= 6.0'
  spec.add_runtime_dependency 'activesupport', '>= 6.0'

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 13'

  spec.add_development_dependency 'rspec-rails', '~> 5'
  spec.add_development_dependency 'sidekiq', '~> 6'
end
