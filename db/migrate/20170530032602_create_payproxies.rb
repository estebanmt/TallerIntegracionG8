class CreatePayproxies < ActiveRecord::Migration[5.0]
  def change
    create_table :payproxies do |t|
      t.decimal :amount
      t.integer :boleta_id

      t.timestamps
    end
    add_index :payproxies, :boleta_id, unique: true
  end
end
