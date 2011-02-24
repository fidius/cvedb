require 'rubygems' # ruby 1.8
require 'bundler'
require 'rake/clean'

Bundler::GemHelper.install_tasks

CLOBBER.include 'pkg'

TEST_FILE = File.join('test', 'cve_parser_test.rb')

namespace :nvd do
  desc 'Test parsing functionality of the gem.'
  task :test do
    sh "ruby #{TEST_FILE}"
  end
end
