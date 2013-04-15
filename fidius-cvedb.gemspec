# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fidius-cvedb/version"

Gem::Specification.new do |s|
  s.name        = "fidius-cvedb"
  s.version     = FIDIUS::CveDb::VERSION
  s.platform    = Gem::Platform::RUBY
  s.add_dependency('nokogiri') 
  s.authors     = ["Andreas Bender", "Jens Färber", "Michael Carlson"]
  s.email       = ["bender@tzi.de", "jfaerber@tzi.de", "me@mbcarlson.org"]
  s.homepage    = "http://fidius.me"
  s.summary     = %q{Provides a parser and ActiveRecord models for the Common Vulnerability and Exposures (CVE) entries offered by the National Vulnerability Database (http://nvd.nist.gov/). }
  s.description = %q{This gem provides an opportunity to run a vulnerability database in your own environment. Therefore it comes with a parser for the National Vulnerability Database and ActiveRecord models for storing the entries in a local database and accessing Entries comfortable with Rails. }

  s.rubyforge_project = ""

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
