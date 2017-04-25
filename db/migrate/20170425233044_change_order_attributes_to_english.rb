class ChangeOrderAttributesToEnglish < ActiveRecord::Migration[5.0]
  def change
    change_table :orders do |t|
      t.rename :canal, :channel
      t.rename :proveedor, :supplier
      t.rename :cliente, :client
      t.rename :cantidad, :amount
      t.rename :cantidad_despachada, :amount_dispatched
      t.rename :precio_unitario, :unit_price
      t.rename :fecha_entrega, :delivery_date
      t.rename :estado, :status
      t.rename :motivo_rechazo, :rejection_motive
      t.rename :motivo_anulacion, :cancellation_motive
      t.rename :notas, :notes
      t.rename :id_factura, :invoice_id
    end
  end
end
