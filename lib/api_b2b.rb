require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require_relative 'api_bodega'
require_relative 'api_orden_compra'
require_relative 'product_table'

class ApiB2b

  #ids de los grupos DEVELOPMENT.... NECESARIO CAMBIARLO A VARIABLES DE ENTORNO!!
  #@ID_GRUPO = ENV["ID_GRUPO"]
  @ID_GRUPO = '590baa00d6b4ec0004902469'
  @ID_GRUPO1 = '590baa00d6b4ec0004902462'
  @ID_GRUPO2 = '590baa00d6b4ec0004902463'
  @ID_GRUPO3 = ''
  @ID_GRUPO4 = '590baa00d6b4ec0004902465'
  @ID_GRUPO5 = '590baa00d6b4ec0004902466'
  @ID_GRUPO6 = ''
  @ID_GRUPO7 = '590baa00d6b4ec0004902468'



  def self.revisarOrdenCompra(json)
    puts "INICIO"
    idOrden = json["_id"]

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

    if json["proveedor"] != @ID_GRUPO
      rechazarOrden(idOrden, 'Id proveedor no corresponde a este grupo')
      return
    end
    puts "proveedor valido"

    # Evaluar factibilidad fechaDespacho

    # Si pasa todas las pruebas se acepta la orden
    iniciarProduccion(json)
    aceptarOrden(idOrden)
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

  #Devuelve cuantos lotes son necesarios producir para llegar al minimo de 100 unidades.
  def self.numeroLote(sku, cantidad)
    h = {'4'=>'200', '6' => '30', '19' => '1420', '20' => '60', '23' => '300', '26' => '144', '27' => '620', '38' => '30', '42' => '200', '53' => '620'}

    if (cantidad==0)
      puts 0
      return 0
    else
      aux = h[sku].to_f
      contador = 1
      while(cantidad > aux)
        aux = aux + h[sku].to_f
        contador = contador +1
      end
      puts contador
      return contador
    end

  end

  #Metodo que compre producto a otro grupo
  def self.comprarProducto(sku, cantidad)
    sku_aux = sku
    cantidad_aux = cantidad
    if (sku_aux=="7")
      precio1 = getPrecio(sku_aux, @ID_GRUPO1)
      precio3 = getPrecio(sku_aux, @ID_GRUPO3)
      precio5 = getPrecio(sku_aux, @ID_GRUPO5)
      precio7 = getPrecio(sku_aux, @ID_GRUPO7)
      #fecha corresponde al 02/06/2017
      ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO1, sku_aux, 1496405760, cantidad_aux, precio1, "b2b", "")
      ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO3, sku_aux, 1496405760, cantidad_aux, precio3, "b2b", "")
      ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO5, sku_aux, 1496405760, cantidad_aux, precio5, "b2b", "")
      ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO7, sku_aux, 1496405760, cantidad_aux, precio7, "b2b", "")
    end
    if (sku_aux=="49")
      precio1 = getPrecio(sku_aux, @ID_GRUPO1)
      precio2 = getPrecio(sku_aux, @ID_GRUPO2)
      precio3 = getPrecio(sku_aux, @ID_GRUPO3)
      #fecha corresponde al 02/06/2017
      ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO1, sku_aux, 1496405760, cantidad_aux, precio1, "b2b", "")
      ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO2, sku_aux, 1496405760, cantidad_aux, precio2, "b2b", "")
      ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO, @ID_GRUPO3, sku_aux, 1496405760, cantidad_aux, precio3, "b2b", "")
     end
  end

  #Retorna precio sku segun grupo
  def self.getPrecio(sku, proveedor)
    listaPrecio = getListaPrecio(proveedor)


    for aux in listaPrecio do
      if JSON.parse(aux)['sku']== sku then
        precio = JSON.parse(aux)['precio']
      end
    end
    return precio
  end

  def self.minMateriasPrimasProducto(sku)

    if(sku=="4")
      if(APIBodega.getTotalStock("4")<100)
        minMateriasPrimasProducto("4")
        APIBodega.producir_Stock_Sin_Pago("4",190)
      end
    end


    #SKU 6... LOTE: 30, necesita: sku: 7 (300), sku: 49 (100)
    if(sku=="6")
      cant6 = APIBodega.getTotalStock("6")
      if(cant6<100)
        lotes = numeroLote("6", 100-cant6)
        cant7 = APIBodega.getTotalStock("7")
        cant49 = APIBodega.getTotalStock("49")
        if ((300*lotes)-cant7>0)
          comprarProducto("7",(300*lotes)-cant7)
        end
        if ((100*lotes)-cant49>0)
          comprarProducto("49", (100*lotes)-cant49)
        end
      end
    end

    if(sku=="53")
      if(APIBodega.getTotalStock("52")<500)
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"3","52", "1495540800", "500", "500", "b2b","COMPRA SKU 52")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e684","52", "1495540800", "500", "500", "b2b","COMPRA SKU 52")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"7","52", "1495540800", "500", "500", "b2b","COMPRA SKU 52")
      end
      if(aux=APIBodega.getTotalStock("26")<63)
        cantidad=63-aux
        cantidadLote("26",cantidad)
        minMateriasPrimasProducto("26")
        APIBodega.producir_Stock_Sin_Pago("26",63)
      end
      if(APIBodega.getTotalStock("38")<250)
        minMateriasPrimasProducto("38")
        APIBodega.producir_Stock_Sin_Pago("38",250)
      end
      if(APIBodega.getTotalStock("7")<651)
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e680","7", "12345678901234", "651", "500", "b2b","COMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"3","7", "12345678901234", "651", "500", "b2b","CCOMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e684","7", "12345678901234", "651", "500", "b2b","CCOMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e686","7", "12345678901234", "651", "500", "b2b","CCOMPRASKU")
      end
      if(APIBodega.getTotalStock("23")<15)
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e680","23", "12345678901234", "15", "500", "b2b","CCOMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"6","23", "12345678901234", "15", "500", "b2b","CCOMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e686","23", "12345678901234", "15", "500", "b2b","COMPRASKU")

      end
    end
    if(sku=="42")
      if(APIBodega.getTotalStock("25")<67)
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e680","25", "12345678901234", "67", "500", "b2b","COMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"3","25", "12345678901234", "67", "500", "b2b","CCOMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e684","25", "12345678901234", "67", "500", "b2b","CCOMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e686","25", "12345678901234", "67", "500", "b2b","COMPRASKU")
      end
      if(APIBodega.getTotalStock("20")<71)
        minMateriasPrimasProducto("20")
        APIBodega.producir_Stock_Sin_Pago("20",71)
      end
      if(APIBodega.getTotalStock("3")<69)
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"3","3", "12345678901234", "69", "500", "b2b","COMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e684","3", "12345678901234", "69", "500", "b2b","COMPRASKU")
      end
    end



  end


  def self.getListaPrecio(id)
    @url = 'http://integra17-' + id + '.ing.puc.cl/api/publico/precios'
    @response = RestClient::Request.execute(
        method: :get,
        url: @url,
        headers: {'Content-Type' => 'application/json'})

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
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

#ApiB2b.cantidadLote("6",113)
#ApiB2b.minMateriasPrimasProducto("6")
#ApiB2b.numeroLote("6", 20)
ApiB2b.getPrecio("1","3")