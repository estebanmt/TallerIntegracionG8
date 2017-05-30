class AddStateToPayproxies < ActiveRecord::Migration[5.0]
  def change
    add_column :payproxies, :state, :integer
  end
end
