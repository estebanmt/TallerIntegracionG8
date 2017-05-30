class RenameBackToAmount < ActiveRecord::Migration[5.0]
  def change
    rename_column("transactions", 'monto',  'amount')

  end
end
