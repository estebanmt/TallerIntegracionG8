require 'api_bodega.rb'
require 'googlecharts'
require 'dashboard_lib'
require 'api_distribuidores.rb'

class DashboardsController < ActionController::Base
  #@ARREGLO_SKUS = ['4', '6', '19', '20', '23', '26', '27', '38', '42', '53']
  ##ACEITE MARA - CREMA - SEMOLA - CACAO - HARINA - SAL -LEVADURA - SEMILLAS_MARAVILLA - CEREAL_MAIZ - PAN INT
  ##GEN-GEN2-RECEP-DESPA-PULM

  # almacenes =  APIBodega.get_almacenes()
  # puts almacenes
  # @ARREGLO_ALMACENES = Array.new
  # for i in 0..almacenes.length-1
  #   @ARREGLO_ALMACENES.push(almacenes[i]["_id"])
  # end

  def index
    # @ARREGLO_SKUS = ['4', '6', '19', '20', '23', '26', '27', '38', '42', '53']
    # almacenes =  APIBodega.get_almacenes()
    # @ARREGLO_ALMACENES = Array.new
    # for i in 0..almacenes.length-1
    #   @ARREGLO_ALMACENES.push(almacenes[i]["_id"])
    # end
    #
    # @dicc_skus = {}
    # obtain_skus(@ARREGLO_ALMACENES, @dicc_skus)
    # @lista_almacenes = []
    # obtener_almacenes(@lista_almacenes)
    @ordenes_fabricacion = OrdenFabricacion.all
    @transactions = Transaction.all
    datos = encontrar_datos
    exitosas = encontrar_exitosas
    boletas = encontrar_datos_boletas
    pendientes = encontrar_pendientes
    @graph = Gchart.pie(  :size => '600x500',
              :title => "Transacciones por monto: Monto - Status",
              :bg => 'efefef',
              :legend => datos.keys,
              :labels => datos.values,
              :data => datos.values)

    @graph1 = Gchart.pie(  :size => '600x500',
              :title => "Transacciones segun exito",
              :bg => 'efefef',
              :legend => ["Exitosas", "Fracasadas"],
              :labels => exitosas,
              :data => exitosas)


    @graph2 = Gchart.pie(  :size => '600x500',
              :title => "Boletas por monto: Monto - Status",
              :bg => 'efefef',
              :legend => boletas.keys,
              :labels => boletas.values,
              :data => boletas.values)

    @graph3 = Gchart.pie(  :size => '600x500',
              :title => "Boletas segun exito",
              :bg => 'efefef',
              :legend => ["Exitosas", "Fracasadas"],
              :labels => pendientes,
              :data => pendientes)


    @stock_por_almacen = DashboardLib.get_almacen_data

    @OCEstados = Odistribuidore.all
    @OCEstados_estados = Odistribuidore.all.group(:estado).count

    @graph4 = Gchart.pie(  :size => '600x500',
              :title => "OC Distribuidores",
              :bg => 'efefef',
              :legend => @OCEstados_estados.keys,
              :labels => @OCEstados_estados.values,
              :data => @OCEstados_estados.values)

  end

  def obtain_skus(lista_alma, diccionario)
    lista_alma.each do |alma|
      response = APIBodega.get_skusWithStock(alma)
      puts response
      response.each do |ris|
        if diccionario[ris["_id"]] == nil
          diccionario[ris["_id"]] = ris["total"]
        else
          diccionario[ris["_id"]] += ris["total"]
        end
      end
    end
  end

  def obtener_almacenes(lista_almacenes)
    almanaque = APIBodega.get_almacenes()
    for i in 0..almanaque.length - 1
      lista = []
      str = ""
      if almanaque[i]["pulmon"]
        str = "Pulmon"
      elsif almanaque[i]["despacho"]
        str = "Despacho"
      elsif almanaque[i]["recepcion"]
        str = "Recepcion"
      else
        str = "General"
      end
      lista << str
      lista << almanaque[i]["usedSpace"]
      lista << almanaque[i]["totalSpace"]
      lista_almacenes << lista
    end
  end

  def encontrar_datos
    montos = {}
    for i in Transaction.all
      placeholder = ''
      if i['exitosa'] == true
        placeholder = " Exitosa"
      else
        placeholder = " Fracasada"
      end
      if montos.key?(i["amount"].to_s+placeholder) #True
        montos[i["amount"].to_s+placeholder] += 1
      else
        montos[i["amount"].to_s+placeholder] = 1
      end
    end
    return montos
  end

  def encontrar_datos_boletas
    montos = {}
    for i in Invoice.all
      placeholder = ''
      if i['status'] == 'pendiente'
        placeholder = " Pendiente"
      else
        placeholder = " Exitosa"
      end
      if montos.key?(i["total_amount"].to_s+placeholder) #True
        montos[i["total_amount"].to_s+placeholder] += 1
      else
        montos[i["total_amount"].to_s+placeholder] = 1
      end
    end
    return montos
  end

  def encontrar_exitosas
    vuelto = [0,0]
    for i in Transaction.all
      if i["exitosa"]
        vuelto[0] += 1
      else
        vuelto[1] += 1
      end
    end
    return vuelto
  end

  def encontrar_pendientes
    vuelto = [0,0]
    for i in Invoice.all
      if i["pendiente"]
        vuelto[0] += 1
      else
        vuelto[1] += 1
      end
    end
    return vuelto
  end

  def facturas
    @facturas = Factura.all
  end

  def ordenes
    @ordenes = Ocompra.all
  end

end
