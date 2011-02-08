



#TODO
#Database Example config
#Gemfile requirements (nokogiri)
#cve establich connection
#rake tasks
#change module for all files to FIDIUS
#implement runner script




# FIDIUS fidius-cvedb

The FIDIUS CVE-DB is used to create your own vulnerability database, based on
the National Vulnerability Database ( http://nvd.nist.gov/ ), or use an already
existing withing your Rails-app.

Therefore it includes rake tasks to download and parse XML files provided by the
NVD, to store and update them in your personal database. Furthermore it includes
ActiveRecord models, migrations and example database configuration to store
Vulnerabilities easily.

This gem is developed in the context of the students project "FIDIUS" at the
University of Bremen, for more information about FIDIUS visit
http://fidius.me/en .

## Installation

Simply install this package with Rubygems:

    $ gem install fidius-cvedb


## Example of use

The setup depends on the context you want to use the gem. It can be used in the
context of the FIDIUS Command&Control Server, or in your own Rails-app. It might
access an already existing database or migrate a new one.

0. Go to your Rails-app folder and run "fidius-cvedb --standalone" or
   "fidius-cvedb --fidius", depending on the context you are using it. For Rails
   versions prior 3 this will create symlinks for the Rake tasks.
   
1. Setup a new CVE Database if you need to or configure an existing one.
  * When you created a new database, run "rake nvd:migrate" to create the tables
    needed.
  * Adapt your database.yml accordingly, the name for your database *MUST* be
    "cve_db" an example could look like this:

    cve_db:
      adapter: mysql2
      encoding: utf8
      database: my_cve_database
      pool: 5
      username: my_username
      password: my_password
      host: localhost

  * 


To use this package as library, follow these steps:

1. do this
2. and
3. that


## Synopsis

This package comes with an executable script. You may invoke it as

    $ gemname-runner [--opt=x|--no-opt=y] <file>

where

* `--opt` does absolutely nothing with `x`
* `--no-opt` does aparently nothing with `y`
* `<file>` is ignores


## Authors and Contact

fidius-cvedb was written by

* FIDIUS Intrusion Detection with Intelligent User Support
  <grp-fidius@tzi.de>, <http://fidius.me>
* in particular:
 * Andreas Bender <bender+fidius-cvedb@tzi.de>
 * Jens Färber <jfaerber+fidius-cvedb@tzi.de>

If you have any questions, remarks, suggestion, improvements,
etc. feel free to drop a line at the addresses given above.
You might also join `#fidius` on Freenode or use the contact
form on our [website](http://fidius.me/en/contact).


## License

Simplified BSD License and GNU GPLv2. See also the file LICENSE.
