

namespace :spree do
  require 'api_spree'

  desc "Spree rake funcion"
  task create_products: :environment do
    puts "#{Time.now} - Spree tasks!"
    APISpree.create_all_object
  end

end
