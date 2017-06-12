class CreateOdistribuidores < ActiveRecord::Migration[5.0]
  def change
    create_table :odistribuidores do |t|
      t.string :estado
      t.string :_id

      t.timestamps
    end
  end
end
