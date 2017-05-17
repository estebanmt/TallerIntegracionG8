require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'

class APIBodega
  @BODEGA_GENERAL = ENV["BODEGA_GENERAL"]
  @BODEGA_GENERAL_2 = ENV["BODEGA_GENERAL_2"]
  @BODEGA_RECEPCION = ENV["BODEGA_RECEPCION"]
  @BODEGA_DESPACHO = ENV["BODEGA_DESPACHO"]
  @BODEGA_PULMON = ENV["BODEGA_PULMON"]

  #@key = '2T02j&xwE#tQA#e'
  @key = ENV["CLAVE_BODEGA"]

  #@API_URL_DEV = 'https://integracion-2017-dev.herokuapp.com/bodega/'
  @API_URL_DEV = ENV["URL_API_BODEGA"]

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

  def self.producirStock19
    producir_Stock_Sin_Pago("19", 2840)
  end
  def self.producirStock20
    producir_Stock_Sin_Pago("20", 2040)
  end
  def self.producirStock26
    producir_Stock_Sin_Pago("26", 2016)
  end
  def self.producirStock27
    producir_Stock_Sin_Pago("27", 2480)
  end
  def self.producirStock38
    producir_Stock_Sin_Pago("38", 2010)
  end



  def self.produceStock
    producir_Stock_Sin_Pago("20", 2040)
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

  def self.producir_Stock(sku, cantidad, trxId)
    hmac = doHashSHA1('PUT'.concat(sku + cantidad + trxId))
    params = {'productoId' => productoId, 'cantidad' => cantidad, 'trxId' => trxId}
    return post_url(@PRODUCIR_STOCK, params, hmac)
  end

  def self.producir_Stock_Sin_Pago(sku, cantidad)
    hmac = doHashSHA1('PUT'+sku.to_s + cantidad.to_s)
    params = {'sku' => sku, 'cantidad' => cantidad}
    result = put_url(@PRODUCIR_STOCK_SIN_PAGO, params, hmac)
    puts result
    return result
  end

  def self.get_Cuenta_Fabrica(sku, cantidad, trxId)
    hmac = doHashSHA1('GET')
    return get_url(@DESPACHAR_STOCK, nil, hmac)
  end

  def self.mover_Recepcion_General(sku, cantidad)
    sku_cantidad = get_skusWithStock(@BODEGA_RECEPCION)
    largo = sku_cantidad.length
    #puts largo
    ids = Array.new
    # puts sku_cantidad[0]["total"]
    for i in 0..largo-1
      skuid = sku_cantidad[i]["_id"].to_s
       if skuid == sku
        cantotal = sku_cantidad[i]["total"].to_i
        if cantidad <=  cantotal
          stock = get_stock(sku.to_s, @BODEGA_RECEPCION)
          for j in 0..stock.length-1
            ids.push(stock[j]["_id"])
          end
        end
       end
    end
    for i in 0..cantidad-1
      mover_Stock(ids[i],@BODEGA_GENERAL)
    end
  end

  def self.mover_General_Despacho(sku, cantidad)
    sku_cantidad = get_skusWithStock(@BODEGA_GENERAL)
    largo = sku_cantidad.length
    ids = Array.new
    for i in 0..largo-1
      skuid = sku_cantidad[i]["_id"].to_s
       if skuid == sku
        cantotal = sku_cantidad[i]["total"].to_i
        # puts cantotal
        if cantidad <=  cantotal
        #  puts "Entro"
          stock = get_stock(sku.to_s, @BODEGA_GENERAL)
          # puts stock
          for j in 0..stock.length-1
            ids.push(stock[j]["_id"])
          end
        end
       end
    end
    for i in 0..cantidad-1
      mover_Stock(ids[i],@BODEGA_DESPACHO)
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
    #puts json
  end

  def self.put_url(uri, params, authorization)
    puts params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth

    @url = @API_URL_DEV + uri
    puts @url

    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    #puts json
  end

end

#APIBodega.get_almacenes()
#APIBodega.get_skusWithStock('590baa77d6b4ec0004902cbf')
#APIBodega.get_stock('53', '590baa77d6b4ec0004902cbf')
#APIBodega.mover_Stock('590baa77d6b4ec0004902e63', '590baa77d6b4ec0004902cbe')
#APIBodega.mover_General_Despacho(53,10)
#APIBodega.mover_Recepcion_General(53,10)
#APIBodega.producir_Stock_Sin_Pago(38,30)
#APIBodega.getTotalStock("26")
#APIBodega.stockPrimasMinimo
#APIBodega.showStockPrimas