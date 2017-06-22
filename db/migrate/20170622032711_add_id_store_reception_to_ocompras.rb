class AddIdStoreReceptionToOcompras < ActiveRecord::Migration[5.0]
  def change
    change_table :ocompras do |t|
      t.string :id_store_reception
    end
  end
end
