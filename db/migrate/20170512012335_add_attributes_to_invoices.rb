class AddAttributesToInvoices < ActiveRecord::Migration[5.0]
  def change
    change_table :invoices do |t|
      t.string :id
      t.string :supplier
      t.string :client
      t.integer :gross_amount
      t.integer :iva
      t.integer :total_amount
      t.string :status
      t.datetime :due_date
      t.string :order_id
      t.string :rejection_motive
      t.string :cancellation_motive
    end
  end
end
