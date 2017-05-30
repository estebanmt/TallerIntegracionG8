class AddAndRenameFieldsInTransactions < ActiveRecord::Migration[5.0]
  def change
    rename_column("transactions", 'amount', 'monto')
    rename_column("transactions", 'sender', 'origen')
    rename_column("transactions", 'receiver', 'destino')
    add_column("transactions", '_id', :string)
    add_column('transactions', 'exitosa', :boolean)
  end
end
