# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'yamg/version'

Gem::Specification.new do |s|
  s.name        = 'yamg'
  s.version     = YAMG::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Marcos Piccinini']
  s.email       = ['nofxx@github.com']
  s.homepage    = 'http://github.com/nofxx/yamg'
  s.summary     = 'Yet another media generator'
  s.description = 'Provides all the media for your projects'
  s.license     = 'MIT'

  s.executables = ['yamg']
  s.default_executable = 'yamg'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'mini_magick'
  s.add_dependency 'rainbow'
end
