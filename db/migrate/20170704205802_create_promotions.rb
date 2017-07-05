class CreatePromotions < ActiveRecord::Migration[5.0]
  def change
    create_table :promotions do |t|
      t.string :sku
      t.integer :precio
      t.datetime :inicio
      t.datetime :fin
      t.boolean :publicar
      t.string :codigo

      t.timestamps
    end
  end
end
