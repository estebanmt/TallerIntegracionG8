class AddColumnsOrdenFabricacion < ActiveRecord::Migration[5.0]
  def change
    add_column('orden_fabricacions', 'monto', :integer)
    add_column('orden_fabricacions', 'disponible', :string)
    add_column('orden_fabricacions', '_id', :string)
  end
end
