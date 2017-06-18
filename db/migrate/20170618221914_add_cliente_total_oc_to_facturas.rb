class AddClienteTotalOcToFacturas < ActiveRecord::Migration[5.0]
  def change
    change_table :facturas do |t|
      t.string :cliente
      t.integer :total
      t.string :oc
    end
  end
end
