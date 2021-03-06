require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require_relative 'api_bodega'
require_relative 'api_orden_compra'
require_relative 'product_table'
require_relative 'api_pago'

class ApiB2b

  # maximo de cantidad para que oc de materia prima se acepte AUTOMATICAMENTE
  @MAX_PRIMA = 200

  #ids de los grupos
  @ID_GRUPO = ENV["ID_GRUPO"]
  @ID_GRUPO1 = ENV["ID_GRUPO1"]
  @ID_GRUPO2 = ENV["ID_GRUPO2"]
  @ID_GRUPO3 = ENV["ID_GRUPO3"]
  @ID_GRUPO4 = ENV["ID_GRUPO4"]
  @ID_GRUPO5 = ENV["ID_GRUPO5"]
  @ID_GRUPO6 = ENV["ID_GRUPO6"]
  @ID_GRUPO7 = ENV["ID_GRUPO7"]

  @ID_GRUPOS = [ @ID_GRUPO1, @ID_GRUPO2, @ID_GRUPO3, @ID_GRUPO4, @ID_GRUPO5, @ID_GRUPO6, @ID_GRUPO7 ]


  @BODEGA_GENERAL = ENV["BODEGA_GENERAL"]
  @BODEGA_DESPACHO = ENV["BODEGA_DESPACHO"]
  # @BODEGA_GENERAL = "5910c0ba0e42840004f6ec42"
  # @BODEGA_DESPACHO = "5910c0ba0e42840004f6ec41"


  # Revisa orden de sistema b2b y lo acepta/rechaza
  def self.revisarOrdenCompra(ordenId, idBodegaCliente)
    puts "INICIO"
    json = ApiOrdenCompra.getOrdenCompra(ordenId)
    puts json
    idOrden = json['_id']

    # revisar que o/c existe
    # revisar que estado sea "creada"
    if json["estado"] != 'creada'
      rechazarOrden(idOrden, 'Estado de orden no es "creada"')
      return
    end
    puts "estado valido"
    puts ProductTable.getProductsSku
    if not ProductTable.getProductsSku.include? json["sku"]
      rechazarOrden(idOrden, 'Este grupo no fabrica: ' + json["sku"])
      return
    end
    puts "sku valido"

    # if json["proveedor"] != @ID_GRUPO
    #   rechazarOrden(idOrden, 'Id proveedor no corresponde a este grupo')
    #   return
    # end
    # puts "proveedor valido"

    # revisar que id cliente sea legitima
    # if not @ID_GRUPOS.include? json["cliente"]
    #   rechazarOrden(idOrden, 'Id de cliente invalida')
    #   return
    # end
    # puts "id cliente valido"

    # revisar que fecha limite sea mayor que actual

    # revisar que canal sea b2b
    if json["canal"] != 'b2b'
      rechazarOrden(idOrden, 'Canal invalido. Debe ser "b2b"')
      return
    end
    puts "canal corresponde a 'b2b'"

    # revisar que precioUnitario > 0
    if json["precioUnitario"] <= 0
      rechazarOrden(idOrden, 'Precio unitarios es muy bajo')
      return
    end
    puts "precio es > 0"

    if json["cantidad"] > 1000
      rechazarOrden(idOrden, 'No se aceptan ordenes de mas de 1000 unidades')
    end
    puts "cantidad aceptable"

    # Si pasa todas las pruebas se acepta la orden
    # iniciarProduccion(json)

    # Se crea la orden en la DB
    puts Ocompra.create("_id": idOrden, "sku": json["sku"], "cantidad": json["cantidad"].to_i,
                        "cliente": json["cliente"], "precioUnitario": json["precioUnitario"],
                        "id_store_reception": idBodegaCliente)

    # Si la orden es por materia prima y menor que cierta cantidad, se acepta e intenta despachar la orden
    # En cualquier otro caso se puede acceder a las o/c desde /dashboard/ordenes para responderlas manualmente
    if json["cantidad"] <= @MAX_PRIMA and ProductTable.getMateriaPrimaSku.include? json["sku"]
      begin
        aceptarOrden(idOrden)
        jsonFactura = ApiPago.crear_factura(idOrden)
        puts "OC ACEPTADA"
        puts jsonFactura
        puts Factura.create("_id": jsonFactura["_id"], "cliente": jsonFactura["cliente"],
                            "total": jsonFactura["total"].to_i, "oc": jsonFactura["oc"])


        APIBodega.despachar_Orden(json["sku"], json["cantidad"].to_i, json["precioUnitario"].to_i,
                                  idBodegaCliente, json["_id"])
        # aceptarOrden(idOrden)
        ApiPago.enviar_notificacion_fatura(jsonFactura["_id"], json["cliente"])



      rescue
        # rechazarOrden(idOrden, 'No se pudo realizar despacho')
        puts "DESPACHO FALLO"
      end
    end

  end

  # Revisa orden de sistema FTP y la acepta/rechaza
  def self.revisarOrdenFtp(ordenId)
    puts "INICIO"
    json = ApiOrdenCompra.getOrdenCompra(ordenId)
    puts "---------------------------INICIO JSON-------------------------------"
    puts json
    puts "----------------------------FIN JSON---------------------------------"
    idOrden = json["_id"]

    #Verificamos el estado
    if json["estado"] == "rechazada"
      return puts 'orden rechazada'
    end

    if json["estado"] == "finalizada"
      return puts 'orden finalizada'
    end

    puts "estado valido"
    puts ProductTable.getProductsSku
    if not ProductTable.getProductsSku.include? json["sku"]
      rechazarOrden(idOrden, 'Este grupo no fabrica: ' + json["sku"])
      return
    end
    puts "sku valido"

    # revisar que fecha limite sea mayor que actual

    # Si pasa todas las pruebas se acepta la orden
    # iniciarProduccion(json)

    # Se verifica que hayan suficientes productos
    cantidad_productos = APIBodega.get_skusWithStock(@BODEGA_GENERAL)
    puts cantidad_productos
    cantidad_sku = 0
    for prod in cantidad_productos
      if prod["_id"].to_s == json["sku"].to_s
        cantidad_sku = prod ["total"].to_i
      end
    end

    puts "cantidad_sku: " + cantidad_sku.to_s


    cantidad_por_despachar = json["cantidad"].to_i - json["cantidadDespachada"].to_i

    if cantidad_por_despachar <= 0
      return puts "Ya se despacho completamente"
    end

    if  cantidad_sku.to_i >= cantidad_por_despachar
      # Se acepta la orden
      puts "Se acepta la orden"
      aceptarOrden(idOrden)
      #ApiPago.crear_factura(idOrden)
      #begin
        # Se intenta despachar la orden
        APIBodega.despachar_Orden_Distribuidor(json["sku"],  cantidad_por_despachar, json["precioUnitario"], json["_id"], json["cliente"])
        puts "Revisar el estado"
        puts ApiOrdenCompra.getOrdenCompra(ordenId)
      #rescue
      #  puts "Entrando a Rescue"
        # Se consulta cuantas unidades quedan por despachar
      #  json = ApiOrdenCompra.getOrdenCompra(ordenId)
      #  cantidad_por_despachar = json["cantidad"].to_i - json["cantidadDespachada"].to_i
        #se intenta seguir despachando
      #  retry
      #end
      return puts "OC aceptada con exito. Factura creada con exito."
    end
  end

  # Para una id de oc intenta: crear factura, guardar en DB, despachar orden y enviar notificacion de factura
  def self.aceptarFacturarDespacharB2b(idOrden, idBodegaCliente)
    begin
    aceptarOrden(idOrden)
      jsonFactura = ApiPago.crear_factura(idOrden)
      puts Factura.create("_id": jsonFactura["_id"], "cliente": jsonFactura["cliente"],
                          "total": jsonFactura["total"].to_i, "oc": jsonFactura["oc"])
      APIBodega.despachar_Orden(json["sku"], json["cantidad"].to_i, json["precioUnitario"].to_i,
                                idBodegaCliente, json["_id"])
      ApiPago.enviar_notificacion_fatura(jsonFactura["_id"], json["cliente"])
      puts "DESPACHO EXITOSO"
    rescue
      puts "DESPACHO FALLO"
    end

  end


  #Metodo que compre producto a otro grupo
  def self.comprarProducto(sku, cantidad)
    sku_aux = sku
    cantidad_aux = cantidad

    #OC para sku 3
    if (sku_aux=="3")
      #precio3 = getPrecio(sku_aux, "3")
      #precio5 = getPrecio(sku_aux, "5")
      precio3 = 300
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO3, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "3")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 3 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO5, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "5")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 5 creada id:" + idOC
    end

    #OC para sku 7
    if (sku_aux=="7")
      #precio1 = getPrecio(sku_aux, "1")
      #precio3 = getPrecio(sku_aux, "3")
      #precio5 = getPrecio(sku_aux, "5")
      #precio7 = getPrecio(sku_aux, "7")
      precio3 = 600

      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO1, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "1")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 1 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO3, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "3")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 3 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO5, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "5")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 5 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO7, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "7")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 7 creada id:" + idOC

    end

    #OC para sku 8
    if (sku_aux=="8")
      #precio1 = getPrecio(sku_aux, "1")
      #precio3 = getPrecio(sku_aux, "3")
      #precio5 = getPrecio(sku_aux, "5")
      #precio7 = getPrecio(sku_aux, "7")
      precio3 = 500

      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO2, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "2")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 2 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO4, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "4")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 4 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO6, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "6")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 6 creada id:" + idOC

    end

    #OC para sku 25
    if (sku_aux=="25")
      #precio1 = getPrecio(sku_aux, "1")
      #precio3 = getPrecio(sku_aux, "3")
      #precio5 = getPrecio(sku_aux, "5")
      #precio7 = getPrecio(sku_aux, "7")
      precio3 = 300

      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO1, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "1")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 1 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO3, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "3")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 3 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO5, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "5")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 5 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO7, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "7")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 7 creada id:" + idOC
    end

    #OC para sku 49
    if sku_aux=="49"
      #precio1 = getPrecio(sku_aux, "1")
      #precio2 = getPrecio(sku_aux, "2")
      #precio3 = getPrecio(sku_aux, "3")
      precio3 = 500

      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO1, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "1")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "grupo1 OC / SKU 49 id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO2, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "2")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "grupo2 OC / SKU 49 id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO3, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "3")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "grupo3 OC / SKU 49 id:" + idOC
    end

    #OC para sku 52
    if (sku_aux=="52")
      #precio3 = getPrecio(sku_aux, "3")
      #precio5 = getPrecio(sku_aux, "5")
      #precio7 = getPrecio(sku_aux, "7")
      precio3 = 900

      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO3, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "3")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 3 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO5, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "5")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 5 creada id:" + idOC
      json_resultado = ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO7, sku_aux, 14964057609999, cantidad_aux, precio3, "b2b", "1")
      idOC = json_resultado['_id']
      begin
        avisarOrdenCompra(idOC, "7")
        puts "notify enviada" + idOC
      rescue => ex
        puts ex.message
      end
      puts "OC grupo 7 creada id:" + idOC
    end

  end

  #Evalua las materias primas del producto ingresado como parametro. SI faltan materias primas
  #para poder producir la cantidad ingresada, se compran o se producen (y devuelve false)
  #SI ya se tiene todas las materias necesarias para producir la cantidad, devuelve true.
  def self.materiasPrimasProducto(sku, cantidad)

    validador = true

    #Sku 4... LOTE: 200, necesito sku: 38 (190 por lote)
    if sku=="4"
      cant4 = APIBodega.getTotalStock("4")
      if cant4 < cantidad
        lotes = numeroLote("4", cantidad-cant4)
        cant38 = APIBodega.getTotalStock("38")
        if (190*lotes)-cant38 > 0
            APIBodega.producirStockSku("38")
            validador = false
        end
      end
    end

    #SKU 6... LOTE: 30, necesita: sku: 7 (300 por lote), sku: 49 (100 por lote)
    if sku=="6"
      cant6 = APIBodega.getTotalStock("6")
      if cant6<cantidad
        lotes = numeroLote("6", cantidad-cant6)
        cant7 = APIBodega.getTotalStock("7")
        cant49 = APIBodega.getTotalStock("49")
        if (300*lotes)-cant7>0
          comprarProducto("7",(300*lotes)-cant7)
          validador = false
        end
        if (100*lotes)-cant49>0
          comprarProducto("49", (100*lotes)-cant49)
          validador = false
        end
      end
    end

    #SKU 23... LOTE: 300, necesita: sku: 8 (309 por lote)
    if sku=="23"
      cant23 = APIBodega.getTotalStock("23")
      if cant23 < cantidad
        lotes = numeroLote("23", cantidad-cant23)
        cant8 = APIBodega.getTotalStock("8")
        if (309*lotes)-cant8 > 0
          comprarProducto("8", (309*lotes)-cant8)
          validador = false
        end
      end
    end

    #SKU 42... LOTE: 200, necesito: sku: 3 (69por lote), 20 (71por lote), 25 (67 por lote)
    if sku=="42"
      cant42 = APIBodega.getTotalStock("42")
      if cant42<cantidad
        lotes = numeroLote("6", cantidad-cant42)
        cant3 = APIBodega.getTotalStock("3")
        cant20 = APIBodega.getTotalStock("20")
        cant25 = APIBodega.getTotalStock("25")
        if (69*lotes)-cant3>0
          comprarProducto("3",(69*lotes)-cant3)
          validador = false
        end
        if (71*lotes)-cant20 > 0
          APIBodega.producirStockSku("20")
          validador = false
        end
        if (67*lotes)-cant25>0
          comprarProducto("25", (67*lotes)-cant25)
          validador = false
        end
      end
    end

    #SKU 53... LOTE: 620, necesito: sku: 7 (651 por lote), 23 (15 por lote), 26 (63 por lote)
    # 38 (250 por lote), 52 (500 por lote)
    if sku=="53"
      cant53 = APIBodega.getTotalStock("53")
      if cant53<cantidad
        lotes = numeroLote("53", cantidad-cant53)
        cant7 = APIBodega.getTotalStock("7")
        cant23 = APIBodega.getTotalStock("23")
        cant26 = APIBodega.getTotalStock("26")
        cant38 = APIBodega.getTotalStock("38")
        cant52 = APIBodega.getTotalStock("52")
        if (651*lotes)-cant7>0
          comprarProducto("7",(651*lotes)-cant7)
          validador = false
        end
        if (15*lotes)-cant23 > 0
          APIBodega.producirStockSku("15")
          validador = false
        end
        if (63*lotes)-cant26 > 0
          APIBodega.producirStockSku("26")
          validador = false
        end
        if (250*lotes)-cant38 > 0
          APIBodega.producirStockSku("38")
          validador = false
        end
        if (500*lotes)-cant52>0
          comprarProducto("52", (500*lotes)-cant52)
          validador = false
        end
      end
    end

    return validador
  end


  #Recibe cantidad a comprar con su sku, y devuelve la cantidad ajustada a comprar por lote.
  def self.cantidadLote(sku, cantidad)
    h = {'4'=>'200', '6' => '30', '19' => '1420', '20' => '60', '23' => '300', '26' => '144', '27' => '620', '38' => '30', '42' => '200', '53' => '620'}
    aux = h[sku].to_f

    while(cantidad > aux)
      aux = aux + h[sku].to_f
    end

    return aux
  end

  #Devuelve cuantos lotes son necesarios producir para llegar a la cantidad deseada
  def self.numeroLote(sku, cantidad)
    h = {'4'=>'200', '6' => '30', '19' => '1420', '20' => '60', '23' => '300', '26' => '144', '27' => '620', '38' => '30', '42' => '200', '53' => '620'}

    if cantidad==0
      return 0
    else
      aux = h[sku].to_f
      contador = 1
      while cantidad > aux
        aux = aux + h[sku].to_f
        contador = contador +1
      end
      return contador
    end
  end

  #Retorna precio de un sku segun proveedor
  def self.getPrecio(sku, proveedor)
    listaPrecio = getListaPrecio(proveedor)
    for aux in listaPrecio do
      if JSON.parse(aux)['sku']== sku then
        precio = JSON.parse(aux)['precio']
      end
    end
    return precio
  end

  #Retorna lista de precios de un proveedor
  def self.getListaPrecio(proveedor)
    @url = 'http://dev.integra17-' + proveedor + '.ing.puc.cl/api/publico/precios'
    @response = RestClient::Request.execute(
        method: :get,
        url: @url,
        headers: {'Content-Type' => 'application/json'})

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    return json
  end

  #Metodo que avisa a otro grupo que se le creo una OC. Se envia PUT a purchase_orders/:id
  def self.avisarOrdenCompra(id, proveedor)

    @url = 'http://dev.integra17-' + proveedor + '.ing.puc.cl/purchase_orders/' + id

    puts @url
    @response= RestClient.put @url, {:id => id}, :content_type => 'application/json'

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    puts json
    return json
  end

  def self.iniciarProduccion(json)
    puts APIBodega.producir_Stock_Sin_Pago(json["sku"], json["cantidad"])
    #puts APIBodega.producir_Stock_Sin_Pago("20", "60")

  end

  def self.rechazarOrden(id, rechazo)
    ApiOrdenCompra.rechazarOrdenCompra(id, rechazo)

    #indicar a otro grupo que se rechazo

  end

  def self.aceptarOrden(id)
    ApiOrdenCompra.recepcionarOrdenCompra(id)

    #indicar a otro grupo que se acepto
  end

end

# ApiB2b.revisarOrdenCompra({"_id"=>"591a3182ea37b2000403c832", "created_at"=>"2017-05-15T22:53:54.091Z",
#                           "updated_at"=>"2017-05-15T22:53:54.091Z", "notas"=>"holaaaaaaaaa",
#                           "cliente"=>"10", "proveedor"=>"590baa00d6b4ec0004902469", "sku"=>"20", "estado"=>"creada",
#                           "fechaDespachos"=>[], "fechaEntrega"=>"9019-04-01T01:58:35.753Z", "precioUnitario"=>10,
#                           "cantidadDespachada"=>0, "cantidad"=>120, "canal"=>"b2b", "__v"=>0}
# )

#ApiB2b.minMateriasPrimasProducto("6")
