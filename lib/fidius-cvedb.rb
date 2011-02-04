require 'fidius-cvedb/version'

module FIDIUS
  module CveDb
    GEM_BASE = File.join(ENV['GEM_HOME'], 'gems', "fidius-cvedb-#{VERSION}", 'lib')
    
    require 'fidius-cvedb/railtie' if defined?(Rails)
    
    require (File.join GEM_BASE, 'models', 'fidius', 'cve_db', 'cve_connection.rb')
    Dir.glob(File.join GEM_BASE, 'models', 'fidius', 'cve_db', '*.rb') do |rb|
      require rb
    end
  end
end