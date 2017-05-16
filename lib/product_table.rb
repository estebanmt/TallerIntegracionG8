class ProductTable

  # SKU | Descripcion | Tipo | Grupo productor | Unidades | Costo Unitario | Lote | # Ingredientes | # Dependientes | Tiempo medio produccion

  public products = [ [4, 'Aceite de Maravilla', 'Producto procesado', 8, 'Lts', 412, 200, 1, 2, 1.205],
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

  public ingredients = [ [4, 'Aceite de Maravilla', 'Lts', 38, 'Semillas Maravilla', 190, 'Kg'],
              [6, 'Crema', 'Lts', 49, 'Leche Descremada', 100, 'Lts'],
              [6, 'Crema', 'Lts', 7, 'Leche', 300, 'Lts'],
              [23, 'Harina', 'Kg', 8, 'Trigo', 309, 'Kg'],
              [42, 'Cereal Maiz', 'Kg', 25, 'Azucar', 67, 'Kg'],
              [42, 'Cereal Maiz', 'Kg', 20, 'Cacao', 71, 'Kg'],
              [42, 'Cereal Maiz', 'Kg', 3, 'Maiz', 69, 'Kg'],
              [53, 'Pan Integral', 'Kg', 52, 'Harina Integral', 500, 'Kg'],
              [53, 'Pan Integral', 'Kg', 26, 'Sal', 63, 'Kg'],
              [53, 'Pan Integral', 'Kg', 7, 'Leche', 651, 'Lts'],
              [53, 'Pan Integral', 'Kg', 23, 'Harina', 15, 'Kg']
  ]
end