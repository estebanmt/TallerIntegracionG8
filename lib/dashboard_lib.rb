require 'api_bodega'
require 'json'
require 'matrix'

class DashboardLib

  # Guarda el desglose de productos por almacen, solo incluye productos que esten en algun almacen
  def self.get_almacen_data
    # Se obtienen datos de la api
    @general = APIBodega.get_skusWithStock(ENV["BODEGA_GENERAL"])
    @despacho = APIBodega.get_skusWithStock(ENV["BODEGA_DESPACHO"])
    @recepcion = APIBodega.get_skusWithStock(ENV["BODEGA_RECEPCION"])
    @pulmon = APIBodega.get_skusWithStock(ENV["BODEGA_PULMON"])

    # Se guardan los datos de cantidad en un hash cuya llave corresponde a una bodega (1=general, 2=despacho, ...)
    aux = Hash.new(0)
    numSkus = 0

    for i in 1..57
      for j in @general
        aux[[1,i]] = getAmountFromId(@general, i.to_s)
      end
      for j in @despacho
        aux[[2,i]] = getAmountFromId(@despacho, i.to_s)
      end
      for j in @recepcion
        aux[[3,i]] = getAmountFromId(@recepcion, i.to_s)
      end
      for j in @pulmon
        aux[[4,i]] = getAmountFromId(@pulmon, i.to_s)
      end
      if not (aux[[1,i]]==0 && aux[[2,i]]==0 && aux[[3,1]]==0 && aux[[4,i]]==0)
        numSkus += 1
      end
    end

    # Se crea un arreglo de largo skusValidos (cantidad > 0) y ancho 6
    response = Array.new(numSkus){Array.new(6)}
    validSkuCounter = 0

    # Las columnas son: sku, general, despacho, recepcion, pulmon, totalProducto
    for i in 1..57
      if not (aux[[1,i]]==0 && aux[[2,i]]==0 && aux[[3,1]]==0 && aux[[4,i]]==0)
        response[validSkuCounter][0] = i
        response[validSkuCounter][1] = aux[[1,i]]
        response[validSkuCounter][2] = aux[[2,i]]
        response[validSkuCounter][3] = aux[[3,i]]
        response[validSkuCounter][4] = aux[[4,i]]
        response[validSkuCounter][5] = aux[[1,i]] + aux[[2,i]] + aux[[3,i]] + aux[[4,i]]
        validSkuCounter += 1
      end
    end

    return response
  end

  # Entrega total de un sku (id) disponible en un almacen
  def self.getAmountFromId(json, id)
    for i in json
      if i["_id"] == id
        return i["total"]
      end
    end
    return 0
  end


end