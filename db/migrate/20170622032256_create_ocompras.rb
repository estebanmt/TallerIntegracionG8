class CreateOcompras < ActiveRecord::Migration[5.0]
  def change
    create_table :ocompras do |t|
      t.string :_id
      t.string :sku
      t.integer :cantidad
      t.string :cliente
      t.integer :precioUnitario

      t.timestamps
    end
  end
end
