class APIBanco
  @CUENTA_FABRICA =  "590baa00d6b4ec0004902460"
  @CUENTA_BANCO = "590baa00d6b4ec0004902470"
  @PRECIO_SKU = ["4": 412, "6": 514, "19": 116, "20": 172, "23":364,
     "26":99, "27": 232, "38": 379, "42": 812, "53": 934]


  def pagar_fabricacion(sku, cantidad_lote)
    total_a_pagar = @PRECIO_SKU[sku]*cantidad_lote


  end
end
