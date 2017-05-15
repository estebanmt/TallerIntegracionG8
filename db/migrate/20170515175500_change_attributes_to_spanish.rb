class ChangeAttributesToSpanish < ActiveRecord::Migration[5.1]
  def change
    change_table :orders do |t|
      t.rename :channel, :canal
      t.rename :supplier, :proveedor
      t.rename :client, :cliente
      t.rename :amount, :cantidad
      t.rename :amount_dispatched, :cantidad_despachada
      t.rename :unit_price, :precio_unitario
      t.rename :delivery_date, :fecha_entrega
      t.rename :status, :estado
      t.rename :rejection_motive, :motivo_rechazo
      t.rename :cancellation_motive, :motivo_anulacion
      t.rename :notes, :notas
      t.rename :invoice_id, :id_factura
    end
  end
end
