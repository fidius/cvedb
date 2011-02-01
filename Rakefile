require 'bundler'
require 'rake/hooks'
require 'rake/clean'
require 'digest/sha1'
require 'find'
require 'rubygems'

Bundler::GemHelper.install_tasks

CLOBBER.include 'pkg'

RAILS_PATH = File.expand_path(File.join('..', '..', 'cve-db', 'cveprovider'))

before :build do
  
  #TODO:
  #copy tests
  #edit readme
  #give db-hints
  #change module for all files to Fidius
  #(git autocommit after copy)
  #implement runner script
  
  copy_files File.join('app', 'models')
  copy_files 'cveparser'
  copy_files File.join('lib', 'tasks')
  copy_files File.join('db', 'migrate')
  
end

# Copies files from cveprovider directory to gem's lib directory
# Only new and changed files will be copied (based on SHA1 Hash) 
def copy_files path
  changed_files = false
  Find.find(File.expand_path(File.join(RAILS_PATH, path))) do |src|
    unless File.directory? src
      rel_src = src.sub(File.join(RAILS_PATH, path.split('/')[0...-1]), "")
      dst = File.expand_path(File.join(File.dirname(__FILE__), 'lib', rel_src))
      
      if File.exists? dst 
        unless Digest::SHA1.hexdigest(File.read(src)) == 
               Digest::SHA1.hexdigest(File.read(dst))
           puts "CHANGE: #{dst}"
           FileUtils.cp(src, dst)
        end
        changed_files = true
      
      else
        FileUtils.mkdir_p(File.dirname(dst))
        FileUtils.cp(src, dst)
        puts "NEW: #{dst}"
        changed_files = true
      end
    end
  end
  changed_files
end
