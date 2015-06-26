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
  s.summary     = 'Names as first class citizens'
  s.description = 'Names as first class citizens'
  s.license     = 'MIT'

  s.executables = ['yamg']
  s.default_executable = 'yamg'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end
