class CreateSpreeMyPays < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_my_pays do |t|
      t.boolean :live
      t.string :event_code
      t.string :psp_reference
      t.string :original_reference
      t.string :merchant_reference
      t.string :merchant_account_code
      t.datetime :event_date
      t.boolean :success
      t.string :payment_method
      t.string :operations
      t.text :reason
      t.string :currency
      t.integer :value
      t.boolean :processed

      t.timestamps
    end
  end
end
