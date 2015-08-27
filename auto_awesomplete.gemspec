# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auto_awesomplete/version'

Gem::Specification.new do |spec|
  spec.name          = 'auto_awesomplete'
  spec.version       = AutoAwesomplete::VERSION
  spec.authors       = ['Dmitry Lisichkin', 'Ivan Zabrovskiy']
  spec.email         = %w(dima@sb42.ru lorowar@gmail.com)
  spec.summary       = %q{Base methods for wrapping a Awesomplete and easy initialize it.}
  spec.description   = <<-DESC
    Gem provide scripts and helpers for initialize different awesomplete elements:
    static and ajax. Moreover this gem is foundation for other gems.
    For example for AutoAwesompleteTag.
  DESC
  spec.homepage      = 'https://github.com/Tab10id/auto_awesomplete'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'railties', '>= 3.1'
  spec.add_dependency 'coffee-rails'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rails', '~> 3.2.12'
end
