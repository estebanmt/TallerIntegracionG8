class CreateReceipts < ActiveRecord::Migration[5.0]
  def change
    create_table :receipts do |t|
      t.string :supplier
      t.string :client
      t.integer :amount

      t.timestamps
    end
  end
end
