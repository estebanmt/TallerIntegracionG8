

namespace :stock do
  require 'api_bodega'

  desc "Check Stock level"
  task check: :environment do
    puts "#{Time.now} - Generate Authorization!"
    puts APIBodega.get_almacenes()
    puts ENV["CLAVE_BODEGA"]
  end

end
