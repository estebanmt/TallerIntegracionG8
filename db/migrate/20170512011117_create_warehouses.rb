class CreateWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouses do |t|
      t.string :id
      t.integer :spaceUsed
      t.integer :spaceTotal
      t.boolean :reception
      t.boolean :dispatch
      t.boolean :lung

      t.timestamps
    end
  end
end
