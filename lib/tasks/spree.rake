

namespace :spree do
  require 'api_spree'

  desc "Spree rake funcion"
  task create_products: :environment do
    puts "#{Time.now} - Spree create_products tasks!"
    APISpree.create_all_object
  end
  task refresh_stock: :environment do
    puts "#{Time.now} - Spree refresh_stock tasks !"
    APISpree.refresh_stock
  end



end
