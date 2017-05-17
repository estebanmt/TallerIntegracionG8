class CreateOrdenFabricacions < ActiveRecord::Migration[5.1]
  def change
    create_table :orden_fabricacions do |t|
      t.string :sku
      t.string :cantidad

      t.timestamps
    end
  end
end
