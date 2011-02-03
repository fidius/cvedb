# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fidius-cvedb/version"

Gem::Specification.new do |s|
  s.name        = "fidius-cvedb"
  s.version     = Fidius::CveDb::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andreas Bender, Jens Färber"]
  s.email       = ["bender@tzi.de, jfaerber@tzi.de"]
  s.homepage    = "http://www.fidius.me"
  s.summary     = %q{Provides a parser and ActiveRecord models for the Common Vulnerability and Exposures (CVE) entries offered by the National Vulnerability Database (http://nvd.nist.gov/). }
  s.description = %q{This gem provides an opportunity to run a vulnerability database in your own environt. Therefore it comes with a parser for the National Vulnerability Database and ActiveRecord models for storing the entries in a local database. }

  s.rubyforge_project = "fidius-cvedb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
