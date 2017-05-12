class AddIdWarehouseIdAndCostToProducts < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.string :id
      t.string :warehouse_id
      t.decimal :cost, :precision=>64, :scale=>12
    end
  end
end
