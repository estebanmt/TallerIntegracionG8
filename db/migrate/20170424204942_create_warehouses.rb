class CreateWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouses do |t|
      t.string :nombre
      t.integer :capacidad
      t.integer :stock

      t.timestamps
    end
  end
end
