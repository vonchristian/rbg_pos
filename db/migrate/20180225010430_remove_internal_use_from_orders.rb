class RemoveInternalUseFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :internal_use, :boolean
  end
end
