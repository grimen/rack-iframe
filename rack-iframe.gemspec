# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/iframe/version"

Gem::Specification.new do |s|
  s.name        = "rack-iframe"
  s.version     = Rack::Iframe::VERSION
  s.authors     = ["Merchii", "Jonas Grimfelt", "Jaakko Suuturla"]
  s.email       = ["operations@merchii.com", "grimen@gmail.com", "jaakko@suutarla.com"]
  s.homepage    = "http://github.com/merchii/rack-iframe"
  s.summary     = %q{Rack middleware for enabling problematic web browsers (Internet Explorer and Safari) to use same cookies in iframes as in parent windows.}
  s.description = s.summary

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rack'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-minitest'
  s.add_development_dependency 'rack-test'
end
