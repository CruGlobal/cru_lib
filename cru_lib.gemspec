# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cru_lib/version'

Gem::Specification.new do |spec|
  spec.name          = 'cru_lib'
  spec.version       = CruLib::VERSION
  spec.authors       = ['Josh Starcher']
  spec.email         = ['josh.starcher@gmail.com']
  spec.summary       = %q{Misc libraries for Cru}
  spec.description   = %q{Collection of common ruby logic used by a number of Cru apps}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.add_dependency 'global_registry'
  spec.add_dependency 'active_model_serializers', '~> 0.10.0rc'
  spec.add_dependency 'redis'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
