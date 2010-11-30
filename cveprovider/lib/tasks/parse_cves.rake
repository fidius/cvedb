# rake nvd:parse FILE=

namespace :nvd do 
  desc 'Parse all xml files which are passed.'
  task :parse do
    sh "rails runner #{Rails.root.to_s}/cveparser/parser.rb #{ENV['FILE']}"
  end
end
