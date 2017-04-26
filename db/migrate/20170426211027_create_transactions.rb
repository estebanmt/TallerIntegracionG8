class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.string :sender
      t.string :receiver

      t.timestamps
    end
  end
end
