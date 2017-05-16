require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'security'
require 'json'
require 'api_bodega'
require 'api_orden_compra'

class ApiB2b

  def self.revisarOrdenCompra(json)
    # revisar que o/c existe
    # revisar que estado sea "creada"
    if json["estado"] != 'creada'
      return false
    end
    # evaluar si se acepta o no
    if evaluarOrdenCompra(json)
      ApiOrdenCompra.recepcionarOrdenCompra(json["_id"])
      # falta avisar al otro grupo
      return true
    else
      ApiOrdenCompra.rechazarOrdenCompra(json["_id"], "Rechazado")
      return false
    end
    # aceptar o rechazar
    # indicar a otro grupo
  end

  def self.evaluarOrdenCompra(json)

  end
end