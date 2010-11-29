require 'find'

BACKUP_DIR = "db"
RAILS_ENV = "development"
MAX_BACKUPS = 5

# Source: http://blog.craigambrose.com/articles/2007/03/01/a-rake-task-for-database-backups
namespace :db do  
  desc "Backup the database to a file." 
  task :backup => [:environment] do
    datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    base_path = BACKUP_DIR || "db" 
    backup_base = File.join(base_path, 'backup')
    backup_folder = File.join(backup_base, datestamp)
    backup_file = File.join(backup_folder, "#{RAILS_ENV}_dump.sql.gz")
    FileUtils.mkdir_p(backup_folder)
    db_config = ActiveRecord::Base.configurations[RAILS_ENV]
    sh "mysqldump -u #{db_config['username']} -p#{db_config['password']} -Q --add-drop-database --opt #{db_config['database']} | gzip -c > #{backup_file}"
    dir = Dir.new(backup_base)
    all_backups = dir.entries[2..-1].sort.reverse
    puts "Created backup: #{backup_file}"
    max_backups = MAX_BACKUPS || 20
    unwanted_backups = all_backups[max_backups..-1] || []
    for unwanted_backup in unwanted_backups
      FileUtils.rm_rf(File.join(backup_base, unwanted_backup))
      puts "deleted #{unwanted_backup}" 
    end
    puts "Deleted #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available" 
  end
end
