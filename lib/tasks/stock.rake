

namespace :stock do
  require 'api_bodega'

  desc "Check Stock level"
  task check: :environment do
    puts "#{Time.now} - Generate Authorization!"
    almacenes =  APIBodega.get_almacenes()
    puts almacenes
    almacenes.each {|almacen| puts almacen[_id]}
    puts ENV["CLAVE_BODEGA"]
  end

end
