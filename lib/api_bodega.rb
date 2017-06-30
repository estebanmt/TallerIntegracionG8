require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require 'httparty'

class APIBodega
  @BODEGA_GENERAL = ENV["BODEGA_GENERAL"]
  @BODEGA_GENERAL_2 = ENV["BODEGA_GENERAL_2"]
  @BODEGA_RECEPCION = ENV["BODEGA_RECEPCION"]
  @BODEGA_DESPACHO = ENV["BODEGA_DESPACHO"]
  @BODEGA_PULMON = ENV["BODEGA_PULMON"]

  ##Produccion
  # @BODEGA_GENERAL = "5910c0ba0e42840004f6ec42"
  # @BODEGA_GENERAL_2 = "5910c0ba0e42840004f6ecd2"
  # @BODEGA_RECEPCION = "5910c0ba0e42840004f6ec40"
  # @BODEGA_DESPACHO = "5910c0ba0e42840004f6ec41"
  # @BODEGA_PULMON = "5910c0ba0e42840004f6ecd3"
  # @key = "kyQqh8B9HPj$Te"
  # @API_URL_BODEGA = 'https://integracion-2017-prod.herokuapp.com/bodega/'
  # @GET_CUENTA_FABRICA = "5910c0910e42840004f6e67e"
  # @URL_PAGO_TRANSFERENCIA = "https://integracion-2017-dev.herokuapp.com/banco"
  # @CUENTA_BANCO = "5910c0910e42840004f6e68d"

  @ingredients = [ [4, 'Aceite de Maravilla', 'Lts', 38, 'Semillas Maravilla', 190, 'Kg'],
              [6, 'Crema', 'Lts', 49, 'Leche Descremada', 100, 'Lts'],
              [6, 'Crema', 'Lts', 7, 'Leche', 300, 'Lts'],
              [23, 'Harina', 'Kg', 8, 'Trigo', 309, 'Kg'],
              [42, 'Cereal Maiz', 'Kg', 25, 'Azucar', 67, 'Kg'],
              [42, 'Cereal Maiz', 'Kg', 20, 'Cacao', 71, 'Kg'],
              [42, 'Cereal Maiz', 'Kg', 3, 'Maiz', 69, 'Kg'],
              [53, 'Pan Integral', 'Kg', 52, 'Harina Integral', 500, 'Kg'],
              [53, 'Pan Integral', 'Kg', 26, 'Sal', 63, 'Kg'],
              [53, 'Pan Integral', 'Kg', 7, 'Leche', 651, 'Lts'],
              [53, 'Pan Integral', 'Kg', 23, 'Harina', 15, 'Kg'],
              [53, 'Pan Integral', 'Kg', 38, 'Semillas Maravilla', 250,'Kg']
  ]

  @LOTE_SKU = ["4" => 200, "6"=> 30, "19"=> 1420, "20"=> 60, "23"=>300,
     "26"=>144, "27"=> 620, "38"=> 30, "42"=> 200, "53"=> 620]


  @key = ENV["CLAVE_BODEGA"]

  @API_URL_BODEGA = ENV["URL_API_BODEGA"]

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

  def self.lista_ingredientes_por_sku(sku)
    #sku => necesario
    totales_por_sku = {}
    for i in @ingredients
      if i[0] == sku.to_i
        totales_por_sku[i[3]] = i[5]
      end
    end
    return totales_por_sku
  end

  def self.doHashSHA1(authorization)
    digest = OpenSSL::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, @key, authorization)

    #puts hmac
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


  #############################################################################
  #SOLUCIONANDO PROBLEMAS CON APIBanco
  #############################################################################


  @CUENTA_FABRICA =  ENV["CUENTA_FABRICA"]
  @CUENTA_BANCO = ENV["CUENTA_BANCO"]
  @COSTO_SKU = ["4" => 412, "6"=> 514, "19"=> 116, "20"=> 172, "23"=>364,
     "26"=>99, "27"=> 232, "38"=> 379, "42"=> 812, "53"=> 934]

  @URL_PAGO_TRANSFERENCIA = ENV["URL_PAGO_TRANSFERENCIA"]


  def self.pagar_fabricacion(sku, cantidad_unitaria)
    total_a_pagar = @COSTO_SKU[0][sku.to_s].to_i*cantidad_unitaria.to_i
    #puts "@COSTO_SKU"
    #puts @COSTO_SKU[0][sku.to_s]*cantidad_unitaria.to_i
    return self.transferir(total_a_pagar)
  end

  def self.transferir(monto)
    hmac = doHashSHA1('PUT')
    params = {'monto' => monto, 'origen' => @CUENTA_BANCO, 'destino' => @CUENTA_FABRICA}
    response = put_url_banco("/trx", params, hmac)
    #return response["_id"]
    return response
  end

  def self.put_url_banco(uri, params, authorization)
    #@auth = 'INTEGRACION grupo8:'.concat(authorization)
    @url = @URL_PAGO_TRANSFERENCIA + uri
    #puts params
    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json#, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    return json
  end

    #############################################################################
    #SOLUCIONANDO PROBLEMAS CON APIBanco
    #############################################################################

  ##PRODUCE un lote de sku, cualquiera, solo necesario el sku
  def self.producirStockSku(sku)
    #puts @LOTE_SKU[0][sku.to_s]
    comprobante_de_pago = pagar_fabricacion(sku, @LOTE_SKU[0][sku.to_s])
    Transaction.create(:amount => comprobante_de_pago["monto"],
    :sender => comprobante_de_pago["origen"], :receiver => comprobante_de_pago["destino"],
    :_id => comprobante_de_pago["_id"], :exitosa => true)
    response = producir_Stock(sku, @LOTE_SKU[0][sku.to_s], comprobante_de_pago["_id"])
    puts response

    OrdenFabricacion.create(:sku => sku.to_s, :cantidad => response["cantidad"],
    :monto => comprobante_de_pago["monto"], :_id => response["_id"],
    :disponible => response["disponible"])
    #producir_Stock(sku, @LOTE_SKU[0][sku.to_s], "592bc3658794840004e952e4")
    #puts response
    return response
  end

  #Solo para productos elaborados, para materia prima llamar diurecto a producirStockSku
  def self.producir_lotes(sku, cantidad_lotes)
    puts "-"*100
    puts verificar_materia_prima_para_producto_elaborado(sku, cantidad_lotes.to_i)
    if verificar_materia_prima_para_producto_elaborado(sku, cantidad_lotes.to_i) #Si pasa, estamos OK
    lista_totales_por_sku = lista_ingredientes_por_sku(sku)
    for k in 0..(cantidad_lotes.to_i - 1)
      for i in lista_totales_por_sku
        puts mover_General_Despacho(i[0], i[1]) # i[0]:sku mat prima, i[1], cantid x lote de mat prima
      end
      puts producirStockSku(sku)
    end
    end
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
    hmac = doHashSHA1('GET'.concat(almacenId.to_s + sku.to_s))
    params = {'almacenId' => almacenId, 'sku' => sku}
    return get_url(@GET_STOCK, params, hmac)
  end

  def self.mover_Stock(productoId, almacenId)
    hmac = doHashSHA1('POST'.concat(productoId).concat(almacenId))
    params = {'almacenId' => almacenId, 'productoId' => productoId}
    return post_url(@MOVE_STOCK, params, hmac)
  end

#Mover para b2b
  def self.mover_Stock_Bodega(productoId, almacenId, oc, precio)
    hmac = doHashSHA1('POST'.concat(productoId).concat(almacenId))
    params = {'almacenId' => almacenId, 'productoId' => productoId, 'oc' => oc, 'precio' => precio}
    return post_url(@MOVE_STOCK_BODEGA, params, hmac)
  end

  def self.despachar_stock_spree(sku, direccion, precio, oc)
    mover_General_Despacho(sku, 1)
    stock = get_stock(sku.to_s, @BODEGA_DESPACHO)
    #despachar_Stock(stock[0]["_id"], direccion, precio, oc)
  end

#Mover pra b2c
  def self.despachar_Stock(productoId, direccion, precio, oc)
    hmac = doHashSHA1('DELETE'.concat(productoId.to_s + direccion.to_s + precio.to_s + oc.to_s))
    params = {'productoId' => productoId, 'direccion' => direccion, 'precio' => precio, 'oc' => oc}
    return delete_url(@DESPACHAR_STOCK, params, hmac)
  end

#Mueve los productos de general a despacho y despues los despacha al almacen del otro grupo
  def self.despachar_Orden(sku, cantidad, precio, direccion, oc)
    for i in 0..cantidad-1
    end
    mover_General_Despacho(sku, cantidad)
    stock = get_stock(sku, @BODEGA_DESPACHO)
    for i in stock
    puts  mover_Stock_Bodega(i["_id"], direccion, oc, precio)
    end
  end

  def self.despachar_Orden_Despacho(sku, cantidad, precio, direccion, oc)
    stock = get_stock(sku, @BODEGA_DESPACHO)
    count = 0
    for i in stock
      puts  mover_Stock_Bodega(i["_id"], direccion, oc, precio)
      count = count + 1
      sleep 1
      if count >= cantidad
        return
      end
    end
  end

#Mueve los productos de general a despacho y despues los despacha al distribuidor
  def self.despachar_Orden_Distribuidor(sku, cantidad, precio, oc, direccion)
    mover_General_Despacho(sku, cantidad)
    stock = get_stock(sku, @BODEGA_DESPACHO)
    while cantidad > 0
      for i in stock
        if cantidad > 0
          puts  despachar_Stock(i["_id"], direccion, precio.to_s, oc)
          puts cantidad -= 1
        else
          return
        end
      end
      stock = get_stock(sku, @BODEGA_DESPACHO)
    end
    return true
  end

  def self.encontrar_sku_total(stock, sku)
    for i in stock
      if i["_id"] == sku.to_i
        return i["total"]
      end
    end
    return 0
  end

  def self.producir_Stock_Sin_Pago(sku, cantidad)
    hmac = doHashSHA1('PUT'+sku.to_s + cantidad.to_s)
    params = {'sku' => sku, 'cantidad' => cantidad}
    OrdenFabricacion.create(sku: sku.to_s, cantidad: cantidad.to_s)
    result = put_url(@PRODUCIR_STOCK_SIN_PAGO, params, hmac)
    return result
  end


  def self.verificar_materia_prima_para_producto_elaborado(sku, cantidad_lotes)
    stock = get_skusWithStock(@BODEGA_GENERAL)
    lista_ingredientes_por_sku = lista_ingredientes_por_sku(sku.to_i) #ingredientes minimos x lote
    for i in lista_ingredientes_por_sku
      for j in stock
        if i[0].to_i == j["_id"].to_i
          if i[1].to_i > j["total"].to_i
            return false
          end
        end
      end
    end
    return true
  end

#se produce un lote, lo llama producirStockSku
  def self.producir_Stock(sku, cantidad, trxId)
   #stock = get_skusWithStock(@BODEGA_GENERAL)
   hmac = doHashSHA1('PUT'.concat(sku.to_s + cantidad.to_s + trxId.to_s))
   params = {'sku' => sku, 'cantidad' => cantidad, 'trxId' => trxId}
   #OrdenFabricacion.create(sku: sku.to_s, cantidad: cantidad.to_s)
   return put_url(@PRODUCIR_STOCK, params, hmac)

  end

  def self.get_Cuenta_Fabrica
    hmac = doHashSHA1('GET')
    return get_url(@GET_CUENTA_FABRICA, nil, hmac)
  end

  def self.mover_Recepcion_General(sku)
    stock = get_stock(sku.to_s, @BODEGA_RECEPCION)
    while stock.length != 0
      for i in 0..stock.length-1
        mover_Stock(stock[i]["_id"],@BODEGA_GENERAL)
        if i != 0 && i%40==0
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
        mover_Stock(stock[i]["_id"],@BODEGA_DESPACHO)
        puts cantidad -= 1
        if i != 0 && i%40==0
          puts 'DURMIENDOOOOOOOO'*10
          sleep(30)
        end
      end
      stock = get_stock(sku.to_s, @BODEGA_GENERAL)
    end
  end

  def self.mover_Despacho_General(sku, cantidad)
    stock = get_stock(sku.to_s, @BODEGA_DESPACHO)
    #puts stock
    while stock.length != 0
      for i in 0..stock.length - 1
        if cantidad == 0
          return 'Hello there, finished moving'
        end
        mover_Stock(stock[i]["_id"],@BODEGA_GENERAL)
        puts cantidad -= 1
        if i != 0 && i%40==0
          puts 'DURMIENDOOOOOOOO'*10
          sleep(15)
        end
      end
      stock = get_stock(sku.to_s, @BODEGA_DESPACHO)
    end
  end

  def self.mover_Pulmon_Recepcion_General(sku, cantidad)
    stock = get_stock(sku.to_s, @BODEGA_PULMON)
    #puts stock
    while stock.length != 0
      for i in 0..stock.length - 1
        if cantidad == 0
          return 'Hello there, finished moving'
        end
        mover_Stock(stock[i]["_id"],@BODEGA_RECEPCION)
        mover_Stock(stock[i]["_id"],@BODEGA_GENERAL)
        cantidad -= 1
        if i != 0 && i%40==0
          #puts 'DURMIENDOOOOOOOO'*10
          sleep(30)
        end
      end
      stock = get_stock(sku.to_s, @BODEGA_PULMON)
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

    if @query_params != nil
      @url = @API_URL_BODEGA + uri + "?" + @query_params
    else
      @url = @API_URL_BODEGA + uri
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
    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    @url = @API_URL_BODEGA + uri
    begin
      @response=RestClient.post @url, params.to_json, :content_type => :json, :accept => :json, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
      puts "response code " + @response.code.to_s
    rescue
      puts "--------------------INTENTANDO NUEVAMENTE--------------------------"
      retry
      #@response=RestClient.post @url, params.to_json, :content_type => :json, :accept => :json, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    end
    json = JSON.parse(@response.body)
    #puts json
  end

  def self.put_url(uri, params, authorization)
    #puts params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth

    @url = @API_URL_BODEGA + uri
    #puts @url

    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    return json
  end

  def self.delete_url(uri, params, authorization)
    #puts json = params.to_json
    #puts @query_params_extra
    #puts @query_params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)

    @url = @API_URL_BODEGA + uri

    @response = HTTParty.delete(@url, {:headers => {'Content-Type' => 'application/json', "Authorization" => @auth},
                                       :body => params.to_json})

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    #puts json
    return json

  end

  def self.probando
    puts "GOLA"
  end

end
#puts APIBodega.get_almacenes
#puts APIBodega.get_skusWithStock("5910c0ba0e42840004f6ec42")
#puts APIBodega.producirStockSku(38)
#puts APIBodega.despachar_Orden_Distribuidor("26",310,297,"5936f1aa42c7c100043f31b2","distribuidor")
#puts APIBodega.get_Cuenta_Fabrica
