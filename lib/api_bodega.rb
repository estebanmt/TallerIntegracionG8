require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'

class APIBodega
  # @BODEGA_GENERAL = ENV["BODEGA_GENERAL"]
  # @BODEGA_GENERAL_2 = ENV["BODEGA_GENERAL_2"]
  # @BODEGA_RECEPCION = ENV["BODEGA_RECEPCION"]
  # @BODEGA_DESPACHO = ENV["BODEGA_DESPACHO"]
  # @BODEGA_PULMON = ENV["BODEGA_PULMON"]
  @BODEGA_GENERAL =  '590baa77d6b4ec0004902cbf'
  @BODEGA_GENERAL_2 = '590baa77d6b4ec0004902ea4'
  @BODEGA_RECEPCION = '590baa77d6b4ec0004902cbd'
  @BODEGA_DESPACHO = '590baa77d6b4ec0004902cbe'
  @BODEGA_PULMON = '590baa77d6b4ec0004902ea5'

  @LOTE_SKU = ["4" => 200, "6"=> 30, "19"=> 1420, "20"=> 60, "23"=>300,
     "26"=>144, "27"=> 620, "38"=> 30, "42"=> 200, "53"=> 620]


  @key = '2T02j&xwE#tQA#e'
  #@key = ENV["CLAVE_BODEGA"]

  @API_URL_DEV = 'https://integracion-2017-dev.herokuapp.com/bodega/'
  #@API_URL_DEV = ENV["URL_API_BODEGA"]

  @URI_GET_ALMACENES = 'almacenes'
  @GET_SKUS_WITH_STOCK = 'skusWithStock'
  @GET_STOCK = 'stock'

  @MOVE_STOCK = 'moveStock'
  @MOVE_STOCK_BODEGA = 'moveStockBodega'

  @DESPACHAR_STOCK = 'stock'

  @PRODUCIR_STOCK = 'fabrica/fabricar'
  @PRODUCIR_STOCK_SIN_PAGO = 'fabrica/fabricarSinPago'
  @GET_CUENTA_FABRICA = 'fabrica/getCuenta'

  def initialize()
  end

  def self.doHashSHA1(authorization)
    digest = OpenSSL::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, @key, authorization)
    puts hmac
    return Base64.encode64(hmac)
  end

  def self.getTotalStock (sku)
    aux1 = get_stock(sku,@BODEGA_GENERAL).count

    aux2 = get_stock(sku,@BODEGA_GENERAL_2).count

    aux3 = get_stock(sku,@BODEGA_RECEPCION).count

    aux4 = get_stock(sku,@BODEGA_PULMON).count

    aux5 = get_stock(sku,@BODEGA_DESPACHO).count

    suma = aux1 + aux2 + aux3 + aux4 + aux5

    return suma
  end

  def self.showStockPrimas
    puts "19:" + getTotalStock("19").to_s
    puts "20:" + getTotalStock("20").to_s
    puts "26:" + getTotalStock("26").to_s
    puts "27:" + getTotalStock("27").to_s
    puts "38:" + getTotalStock("38").to_s
  end
##AREGLAR ESTO

# PIOLA
  def self.minMateriasPrimasPropias()
    if (getTotalStock("19")<2000)
      producir_Stock_Sin_Pago("19", 2840)
    end
    if (getTotalStock("20")<2000)
      producir_Stock_Sin_Pago("20", 2040)
    end
    if (getTotalStock("26")<2000)
      producir_Stock_Sin_Pago("26", 2016)
    end
    if (getTotalStock("27")<2000)
      producir_Stock_Sin_Pago("27", 2480)
    end
    if (getTotalStock("38")<2000)
      producir_Stock_Sin_Pago("38", 2010)
    end
  end

  # def self.producirStock19
  #   APIBanco.pagar_fabricacion(19,116)
  # end
  # def self.producirStock20
  #   producir_Stock_Sin_Pago("20", 2040)
  # end
  # def self.producirStock26
  #   producir_Stock_Sin_Pago("26", 2016)
  # end
  # def self.producirStock27
  #   producir_Stock_Sin_Pago("27", 2480)
  # end
  # def self.producirStock38
  #   producir_Stock_Sin_Pago("38", 2010)
  # end


  ##PRODUCE un lote de sku
  def self.producirStockSku(sku)
    comprobante_de_pago = APIBanco.pagar_fabricacion(sku, @LOTE_SKU[sku])
    producir_Stock(sku, @LOTE_SKU[sku], comprobante_de_pago["_id"])
  end

  def self.producir_lotes(sku, cantidad_lotes)

  end


  def self.get_almacenes ()
    hmac = doHashSHA1('GET')
    return get_url(@URI_GET_ALMACENES, nil, hmac)
  end

  def self.get_skusWithStock(almacenId)
    hmac = doHashSHA1('GET'.concat(almacenId))
    params = {'almacenId' => almacenId}
    return get_url(@GET_SKUS_WITH_STOCK, params, hmac)
  end

  def self.get_stock(sku, almacenId)
    hmac = doHashSHA1('GET'.concat(almacenId + sku))
    params = {'almacenId' => almacenId, 'sku' => sku}
    return get_url(@GET_STOCK, params, hmac)
  end


  def self.mover_Stock(productoId, almacenId)
    hmac = doHashSHA1('POST'.concat(productoId).concat(almacenId))
    params = {'almacenId' => almacenId, 'productoId' => productoId}
    return post_url(@MOVE_STOCK, params, hmac)
  end

  def self.mover_Stock_Bodega(productoId, almacenId, oc, precio)
    hmac = doHashSHA1('POST'.concat(productoId).concat(almacenId))
    params = {'almacenId' => almacenId, 'productoId' => productoId, 'oc' => oc, 'precio' => precio}
    return post_url(@MOVE_STOCK_BODEGA, params, hmac)
  end

  def self.despachar_Stock(productoId, direccion, precio, oc)
    hmac = doHashSHA1('DELETE'.concat(productoId + direccion + precio + oc))
    params = {'productoId' => productoId, 'direccion' => direccion, 'precio' => precio, 'oc' => oc}
    return get_url(@DESPACHAR_STOCK, params, hmac)
  end

  def self.encontrar_sku_total(stock, sku)
    for i in stock
      if i["_id"] == sku.to_i
        return i["total"]
      end
    end
    return 0
  end

  def self.verificar_materia_prima_para_producto_elaborado(sku, cantidad_lotes)
    stock = get_skusWithStock(@BODEGA_GENERAL)
    lista_ingredientes_por_sku = ProductTable.lista_ingredientes_por_sku(sku.to_i) #ingredientes minimos x lote
    for i in lista_ingredientes_por_sku
      puts i.key
    end
    return true
  end
#cantidad debe ser multiple de lote
  def self.producir_Stock(sku, cantidad, trxId)
    stock = get_skusWithStock(@BODEGA_GENERAL)

    case sku
    when 4
      total = encontrar_sku_total(stock, 38)
      mover = cantidad/200*190
      if total >= mover
        mover_General_Despacho(38,mover)
      end
      puts arreglo[sku]
    when 6
      puts arreglo[sku]
    when "20"
      puts arreglo[sku.to_i]
    when 23
      puts arreglo[sku]
    when 42
      puts arreglo[sku]
    when 53
      puts arreglo[sku]

    end
   hmac = doHashSHA1('PUT'.concat(sku.to_s + cantidad.to_s + trxId.to_s))
   params = {'sku' => sku, 'cantidad' => cantidad, 'trxId' => trxId}
   #OrdenFabricacion.create(sku: sku.to_s, cantidad: cantidad.to_s)
   return put_url(@PRODUCIR_STOCK, params, hmac)
  end

  def self.producir_Stock_Sin_Pago(sku, cantidad)
    hmac = doHashSHA1('PUT'+sku.to_s + cantidad.to_s)
    params = {'sku' => sku, 'cantidad' => cantidad}
    OrdenFabricacion.create(sku: sku.to_s, cantidad: cantidad.to_s)
    result = put_url(@PRODUCIR_STOCK_SIN_PAGO, params, hmac)
    puts result
    return result
  end

  def self.get_Cuenta_Fabrica(sku, cantidad, trxId)
    hmac = doHashSHA1('GET')
    return get_url(@DESPACHAR_STOCK, nil, hmac)
  end

  def self.mover_Recepcion_General(sku)
    stock = get_stock(sku.to_s, @BODEGA_RECEPCION)
    while stock.length != 0
      for i in 0..stock.length-1
        puts mover_Stock(stock[i]["_id"],@BODEGA_GENERAL)
        if i != 0 && i%50==0
          puts 'DURMIENDOOOOOOOO'*10
          sleep(15)
        end
      end
      stock = get_stock(sku.to_s, @BODEGA_RECEPCION)
    end
  end

  def self.vaciar_bodega_recepcion
    sku_cantidad = get_skusWithStock(@BODEGA_RECEPCION)
    for i in sku_cantidad
      #puts i["_id"]
      mover_Recepcion_General(i["_id"])
    end
    puts "termino de vaciar recepcion"
  end


  def self.mover_General_Despacho(sku, cantidad)
    stock = get_stock(sku.to_s, @BODEGA_GENERAL)
    #puts stock
    while stock.length != 0
      for i in 0..stock.length - 1
        if cantidad == 0
          return 'Hello there, finished moving'
        end
        puts mover_Stock(stock[i]["_id"],@BODEGA_DESPACHO)
        cantidad -= 1
        if i != 0 && i%50==0
          puts 'DURMIENDOOOOOOOO'*10
          sleep(15)
        end
      end
      stock = get_stock(sku.to_s, @BODEGA_GENERAL)
    end
  end

  def self.query_params(params)
    if params != nil
      queryParams = "";
      params.each do |field, value|
        queryParams.concat(field).concat("=").concat(value).concat("&");
        #queryParams = queryParams + field + "=" + value + "&";
      end
      return queryParams
    else
      return nil;
    end
  end


  def self.get_url(uri, params, authorization)
    #puts params

    @query_params = query_params(params)
    #puts @query_params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    puts @auth

    if @query_params != nil
      @url = @API_URL_DEV + uri + "?" + @query_params
    else
      @url = @API_URL_DEV + uri
    end
    puts @url

    @response = RestClient::Request.execute(
        method: :get,
        url: @url,
        headers: {'Content-Type' => 'application/json',
                  "Authorization" => @auth})

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    #puts json

    return json

  end

  def self.post_url(uri, params, authorization)
    puts params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    puts @auth

    @url = @API_URL_DEV + uri
    puts @url

    @response=RestClient.post @url, params.to_json, :content_type => :json, :accept => :json, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    puts json
  end

  def self.put_url(uri, params, authorization)
    #puts params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth

    @url = @API_URL_DEV + uri
    #puts @url

    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    puts json
  end

end

#APIBodega.get_almacenes()
#APIBodega.get_skusWithStock('590baa77d6b4ec0004902cbf')
#APIBodega.get_stock('53', '590baa77d6b4ec0004902cbf')
#APIBodega.mover_Stock('590baa77d6b4ec0004902e63', '590baa77d6b4ec0004902cbe')
#APIBodega.mover_General_Despacho(53,10)
#APIBodega.mover_Recepcion_General(20)
#APIBodega.producir_Stock_Sin_Pago(38,30)
#APIBodega.getTotalStock("26")
#APIBodega.stockPrimasMinimo
#APIBodega.showStockPrimas
#Array.new(len,val)
#APIBodega.producir_Stock(20, 60, "59273a0a2f064d0004c979fd")
#APIBodega.vaciar_bodega_recepcion
##puts APIBodega.mover_General_Despacho(38, 151)
#APIBodega.producir_Stock("20", 200, 20)
#APIBodega.verificar_materia_prima_para_producto_elaborado(4,1)
