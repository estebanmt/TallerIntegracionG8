class AddSkusAndQtyToOdistribuidores < ActiveRecord::Migration[5.0]
  def change
    change_table :odistribuidores do |t|
      t.string :sku
      t.integer :ammount
    end
  end
end
