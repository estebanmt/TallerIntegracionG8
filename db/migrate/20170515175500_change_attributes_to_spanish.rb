class ChangeAttributesToSpanish < ActiveRecord::Migration[5.0]
  def change
    change_table :orders do |t|
      t.rename :channel, :canal
      t.rename :supplier, :proveedor
      t.rename :client, :cliente
      t.rename :amount, :cantidad
      t.rename :amount_dispatched, :cantidadDespachada
      t.rename :unit_price, :precioUnitario
      t.rename :delivery_date, :fechaEntrega
      t.rename :status, :estado
      t.rename :rejection_motive, :rechazo
      t.rename :cancellation_motive, :anulacion
      t.rename :notes, :notas
      t.rename :invoice_id, :id_factura
      t.rename :order_id, :_id
    end
  end
end
