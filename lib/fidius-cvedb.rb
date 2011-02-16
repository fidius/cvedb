require 'fidius-cvedb/version'

module FIDIUS
  module CveDb
    GEM_BASE = File.expand_path('..', __FILE__)
    RAILS_VERSION = Rails.version.to_i
    
    # If the used Rails version is 3 or beyond we use railties to load the rake
    # tasks. Otherwise they are symlinked.
    require 'fidius-cvedb/railtie' unless RAILS_VERSION < 3
    
    require (File.join GEM_BASE, 'models', 'fidius', 'cve_db', 'cve_connection.rb')
    Dir.glob(File.join GEM_BASE, 'models', 'fidius', 'cve_db', '*.rb') do |rb|
      require rb
    end
  end
end
