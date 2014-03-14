# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-frisk/version"

Gem::Specification.new do |s|
  s.name             = "knife-frisk"
  s.version          = Knife::Frisk::VERSION
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.licenses         = ['MIT']
  s.authors          = ["Lisa Walley"]
  s.email            = ["lisa@lisawalley..com"]
  s.homepage         = "https://github.com/lwalley/knife-frisk"
  s.summary          = %q{Plugin to extract and combine data from nodes and custom defined data bags.}
  s.description      = s.summary

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]
end
