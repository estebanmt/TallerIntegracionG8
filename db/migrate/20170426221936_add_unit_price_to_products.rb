class AddUnitPriceToProducts < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.integer :unit_price
    end
  end
end
