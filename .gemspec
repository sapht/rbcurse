# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
#require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name        = "rbcurse"
  s.version     = "1.4.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["rkumar"]
  s.email       = ["admin@example.com"]
  s.homepage    = "http://example.com"
  s.summary     = "test"
  s.description = "testdesc"
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rbcurse"
 
  #s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{lib,examples}/**/*") + %w(README.markdown TODO2.txt NOTES)
  #s.executables  = ['bundle']
  s.require_path = 'lib'
end

