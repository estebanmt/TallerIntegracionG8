class Promotion < ApplicationRecord

  def self.promotions
    @url = 'amqp://ptphrjfb:nJCPrYiNLjCppuAHhaQ0kBLnhm6ZPoHe@fish.rmq.cloudamqp.com/ptphrjfb' #Develop
    #@url = 'amqp://vwzvzszy:_Zx0jzEFDlDRZU5F8-gQDfhX_dF7tlzL@fish.rmq.cloudamqp.com/vwzvzszy' #Production
    conection = Bunny.new(@url)
    conection.start
    channel = conection.create_channel
    queue = channel.queue('ofertas', :auto_delete => true)
    queue.subscribe do |delivery_info, metadata, payload|
      oferta = JSON.parse(payload)
      inicio = ActiveSupport::TimeZone['America/Santiago'].parse(Date.strptime(oferta['inicio'].to_s, '%Q').to_s).beginning_of_day
      fin = ActiveSupport::TimeZone['America/Santiago'].parse(Date.strptime(oferta['fin'].to_s, '%Q').to_s).end_of_day
      Promotion.create(:sku => oferta['sku'].to_s, :precio => oferta['precio'].to_i,
      :inicio => inicio, :fin => fin, :codigo => oferta['codigo'])
    end
    # promociones = Promotion.all
    # for i in promociones
    #   puts i
    # end
  end
end
