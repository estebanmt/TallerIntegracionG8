require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require_relative 'api_bodega'
require_relative 'api_orden_compra'
require_relative 'product_table'

class ApiB2b


  @ID_GRUPO = ENV["ID_GRUPO"]

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

  def self.minMateriasPrimasProducto(sku)
    if(sku=="53")
      if(APIBodega.getTotalStock("52")<500)
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"3","52", "1495540800", "500", "500", "b2b","COMPRA SKU 52")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e684","52", "1495540800", "500", "500", "b2b","COMPRA SKU 52")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"7","52", "1495540800", "500", "500", "b2b","COMPRA SKU 52")
      end
      if(APIBodega.getTotalStock("26")<63)
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
    if(sku=="6")
      if(APIBodega.getTotalStock("7")<300)
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e680","7", "12345678901234", "300", "500", "b2b","COMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"3","7", "12345678901234", "300", "500", "b2b","COMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e684","7", "12345678901234", "300", "500", "b2b","COMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e686","7", "12345678901234", "300", "500", "b2b","COMPRASKU")
      end
      if(APIBodega.getTotalStock("49")<100)
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e680","49", "12345678901234", "100", "500", "b2b","COMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"5910c0910e42840004f6e681","49", "12345678901234", "100", "500", "b2b","CCOMPRASKU")
        ApiOrdenCompra.crearOrdenCompra(@ID_GRUPO,"3","49", "12345678901234", "100", "500", "b2b","COMPRASKU")
      end
    end

    if(sku=="4")
      if(APIBodega.getTotalStock("4")<190)
        minMateriasPrimasProducto("4")
        APIBodega.producir_Stock_Sin_Pago("4",190)
      end
    end
  end

  def self.comprarMateria(sku,cantidad)
    ApiOrdenCompra.crearOrdenCompra
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
