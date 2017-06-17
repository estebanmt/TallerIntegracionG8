class AddDispatchedQtyToOdistribuidores < ActiveRecord::Migration[5.0]
  def change
    change_table :odistribuidores do |t|
      t.integer :despachado
    end
  end
end
