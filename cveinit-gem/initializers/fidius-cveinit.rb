databases = YAML.load_file File.join(RAILS_ROOT, 'config', 'database.yml')
unless databases['cve_db']
  raise ArgumentError.new "Missing CVE-DB configuration. Please add a section `cve_db' to your database.yml"
end