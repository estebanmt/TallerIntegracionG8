require 'api_bodega.rb'
class DashboardsController < ActionController::Base
  @ARREGLO_SKUS = ['4', '6', '19', '20', '23', '26', '27', '38', '42', '53']
  ##ACEITE MARA - CREMA - SEMOLA - CACAO - HARINA - SAL -LEVADURA - SEMILLAS_MARAVILLA - CEREAL_MAIZ - PAN INT
  @ARREGLO_ALMACENES = ['590baa77d6b4ec0004902cbf', '590baa77d6b4ec0004902ea4', '590baa77d6b4ec0004902cbd', '590baa77d6b4ec0004902cbe', '590baa77d6b4ec0004902ea5']
  ##GEN-GEN2-RECEP-DESPA-PULM

  def index
    @ARREGLO_SKUS = ['4', '6', '19', '20', '23', '26', '27', '38', '42', '53']
    @ARREGLO_ALMACENES = ['590baa77d6b4ec0004902cbf', '590baa77d6b4ec0004902ea4',
       '590baa77d6b4ec0004902cbd', '590baa77d6b4ec0004902cbe',
        '590baa77d6b4ec0004902ea5']
    @dicc_skus = {}
    obtain_skus(@ARREGLO_ALMACENES, @dicc_skus)
    @lista_almacenes = []
    obtener_almacenes(@lista_almacenes)

  end

  def obtain_skus(lista_alma, diccionario)
    lista_alma.each do |alma|
      response = APIBodega.get_skusWithStock(alma)
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

end
