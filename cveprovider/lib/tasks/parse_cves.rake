# rake nvd:parse FILE=

namespace :nvd do 
  desc 'Parse all xml files which are passed.'
  task :parse do
    if Rails.version[0].to_i < 3
      sh "ruby script/runner #{Rails.root.to_s}/cveparser/parser.rb #{ENV['FILE']}"
    else
      sh "rails runner #{Rails.root.to_s}/cveparser/parser.rb #{ENV['FILE']}"
    end
  end
end
