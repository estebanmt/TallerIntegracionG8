

namespace :stock do
  require 'api_bodega'

  desc "Check Stock level"
  task check: :environment do
    puts "#{Time.now} - Generate Authorization!"
    almacenes =  APIBodega.get_almacenes()
    puts almacenes
    ids = Array.new
    for i in 0..almacenes.length-1
      ids.push(almacenes[i]["_id"])
    end
    puts ids
    puts ENV["CLAVE_BODEGA"]
  end

end
