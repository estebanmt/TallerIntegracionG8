

namespace :stock do
  require 'api_bodega'

  desc "Check Stock level"
  task check: :environment do
    puts "#{Time.now} - Generate Authorization!"
    APIBodega.get_almacenes()
  end

end
