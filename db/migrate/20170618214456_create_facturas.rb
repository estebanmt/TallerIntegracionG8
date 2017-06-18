class CreateFacturas < ActiveRecord::Migration[5.0]
  def change
    create_table :facturas do |t|
      t.string :_id

      t.timestamps
    end
  end
end
