class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :order_id
      t.string :canal
      t.string :proveedor
      t.string :cliente
      t.string :sku
      t.integer :cantidad
      t.integer :cantidad_despachada
      t.integer :precio_unitario
      t.datetime :fecha_entrega
      t.string :estado
      t.string :motivo_rechazo
      t.string :motivo_anulacion
      t.string :notas
      t.string :id_factura

      t.timestamps
    end
  end
end
