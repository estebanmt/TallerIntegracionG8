class RenameBackToReceiverSender < ActiveRecord::Migration[5.0]
  def change
  rename_column("transactions", 'origen','sender')
  rename_column("transactions", 'destino', 'receiver')

  end
end
