class EmptyReceptionJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    APIBodega.vaciar_bodega_recepcion
    puts "ENTRO "*30
  end
end
