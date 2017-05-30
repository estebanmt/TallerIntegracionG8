

namespace :bodega do
  require 'api_bodega'

  desc "Empty bodega-recepcion"
  task vaciar_bodega_recepcion: :environment do
    puts "#{Time.now} - Generate Authorization!"
    #APIBodega.vaciar_bodega_recepcion
    puts "-."*100
  end

end
