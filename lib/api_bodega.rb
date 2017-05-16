require 'rest_client'
require 'openssl'
require "base64"
require 'digest'

class APIBodega
  @BODEGA_GENERAL = '590baa77d6b4ec0004902cbf'
  @BODEGA_GENERAL_2 = '590baa77d6b4ec0004902ea4'
  @BODEGA_RECEPCION = '590baa77d6b4ec0004902cbd'
  @BODEGA_DESPACHO = '590baa77d6b4ec0004902cbe'
  @BODEGA_PULMON = '590baa77d6b4ec0004902ea5'

  @key = '2T02j&xwE#tQA#e'
  @API_URL_DEV = 'https://integracion-2017-dev.herokuapp.com/bodega/'
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
    return Base64.encode64(hmac)
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
    return get_url(@PRODUCIR_STOCK, params, hmac)
  end

  def self.producir_Stock_Sin_Pago(sku, cantidad)
    hmac = doHashSHA1('PUT'.concat(sku + cantidad))
    params = {'productoId' => productoId, 'cantidad' => cantidad}
    return get_url(@PRODUCIR_STOCK_SIN_PAGO, params, hmac)
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
      skuid = sku_cantidad[i]["_id"].to_f
       if skuid == sku
        cantotal = sku_cantidad[i]["total"].to_f
        # puts cantotal
        if cantidad <=  cantotal
        #  puts "Entro"
          stock = get_stock(sku.to_s, @BODEGA_RECEPCION)
          # puts stock
          for j in 0..stock.length-1
            ids.push(stock[j]["_id"])
          end
        end
       end
    end
    # puts ids
    for i in 0..cantidad-1
      mover_Stock(ids[i],@BODEGA_GENERAL)
    end
  end

  def self.mover_General_Despacho(sku, cantidad)
    sku_cantidad = get_skusWithStock(@BODEGA_GENERAL)

    largo = sku_cantidad.length
    #puts largo
    ids = Array.new

    # puts sku_cantidad[0]["total"]
    for i in 0..largo-1
      skuid = sku_cantidad[i]["_id"].to_f
       if skuid == sku
        cantotal = sku_cantidad[i]["total"].to_f
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

    # puts ids

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
    #puts @auth

    if @query_params != nil
      @url = @API_URL_DEV + uri + "?" + @query_params
    else
      @url = @API_URL_DEV + uri
    end
    #puts @url

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
    # puts params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth

    @url = @API_URL_DEV + uri
    # puts @url

    @response=RestClient.post @url, params.to_json, :content_type => :json, :accept => :json, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
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
#APIBodega.mover_Recepcion_General(53,10)
