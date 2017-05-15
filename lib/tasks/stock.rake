

namespace :stock do
  require 'api_bodega'

  desc "Check Stock level"
  task check: :environment do
    puts "#{Time.now} - Generate Authorization!"
    APIBodega.GET_ALMACENES('590baa77d6b4ec0004902cbf')
  end

end
