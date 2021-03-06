require 'api_bodega'
require 'json'

class ProductTable

  @BODEGA_GENERAL =  ENV["BODEGA_GENERAL"]

  @PRECIO_ACEITE = ((772*1.2).to_i).to_s
  @PRECIO_CREMA = ((5380*1.2).to_i).to_s
  @PRECIO_SEMOLA = ((116*1.2).to_i).to_s
  @PRECIO_CACAO = ((172*1.2).to_i).to_s
  @PRECIO_HARINA = ((624*1.2).to_i).to_s
  @PRECIO_SAL = ((144*1.2).to_i).to_s
  @PRECIO_LEVADURA = ((232*1.2).to_i).to_s
  @PRECIO_SEMILLAS = ((370*1.2).to_i).to_s
  @PRECIO_CEREAL = ((1757*1.2).to_i).to_s
  @PRECIO_PAN = ((1590*1.2).to_i).to_s

  # SKU | Descripcion | Tipo | Grupo productor | Unidades | Costo Unitario | Lote | # Ingredientes | # Dependientes | Tiempo medio produccion

  @products = [ [4, 'Aceite de Maravilla', 'Producto procesado', 8, 'Lts', 412, 200, 1, 2, 1.205],
               [6, 'Crema', 'Producto procesado', 8, 'Lts', 514, 30, 2, 2, 2.481],
               [19, 'Semola', 'Materia prima', 8, 'Kg', 116, 1420, 0, 1, 1.881],
               [20, 'Cacao', 'Materia prima', 8, 'Kg', 172, 60, 0, 5, 2.258],
               [23, 'Harina', 'Producto procesado', 8, 'Kg', 364, 300, 1, 6, 0.910],
               [26, 'Sal', 'Materia prima', 8, 'Kg', 99, 144, 0, 7, 3.059],
               [27, 'Levadura', 'Materia prima', 8, 'Kg', 232, 620, 0, 4, 1.566],
               [38, 'Semillas Maravilla', 'Materia prima', 8, 'Kg', 379, 30, 0, 3, 3.462],
               [42, 'Cereal Maiz', 'Producto procesado', 8, 'Kg', 812, 200, 3, 0, 2.743],
               [53, 'Pan Integral', 'Producto', 8, 'Kg', 934, 620, 5, 0, 2.400]
  ]

  # SKU | Descripcion | Unidad | SKU ingrediente | Ingrediente | Requerimiento | Unidad Ingrediente

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

  @productsSku = [4, 6, 19, 20, 23, 26, 27, 38, 42, 53]



  def initialize()
  end

  def self.getProducts
    return products
  end

  def self.getIngredients
    return ingredients
  end

  def self.getMateriaPrimaSku
    return ['19', '20', '26', '27', '38']
  end

  def self.getProductsSku
    return ['4', '6', '19', '20', '23', '26', '27', '38', '42', '53']
  end

  def self.priceList
    json = APIBodega.get_skusWithStock(@BODEGA_GENERAL)

    puts getStockFromJson('4', json)

    @response = '[{"sku": "4", "precio": ' + @PRECIO_ACEITE + ', "stock": ' + getStockFromJson('4', json) + '},' +
'{"sku": "6", "precio": ' + @PRECIO_CREMA + ', "stock": ' + getStockFromJson('6', json) + '},' +
'{"sku": "19", "precio": ' + @PRECIO_SEMOLA + ', "stock": ' + getStockFromJson('19', json) + '},' +
'{"sku": "20", "precio": ' + @PRECIO_CACAO + ', "stock": ' + getStockFromJson('20', json) + '},' +
'{"sku": "23", "precio": ' + @PRECIO_HARINA + ', "stock": ' + getStockFromJson('23', json) + '},' +
'{"sku": "26", "precio": ' + @PRECIO_SAL + ', "stock": ' + getStockFromJson('26', json) + '},' +
'{"sku": "27", "precio": ' + @PRECIO_LEVADURA + ', "stock": ' + getStockFromJson('27', json) + '},' +
'{"sku": "38", "precio": ' + @PRECIO_SEMILLAS + ', "stock": ' + getStockFromJson('38', json) + '},' +
'{"sku": "42", "precio": ' + @PRECIO_CEREAL + ', "stock": ' + getStockFromJson('42', json) + '},' +
'{"sku": "53", "precio": ' + @PRECIO_PAN + ', "stock": ' + getStockFromJson('53', json) + '}]'

    return @response
  end

  def self.getStockFromJson(id, json)
    for i in json
      if i['_id'] == id
        return i['total'].to_s
      end
    end

    return '0'

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

end
