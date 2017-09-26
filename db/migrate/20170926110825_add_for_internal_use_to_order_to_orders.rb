class AddForInternalUseToOrderToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :internal_use, :boolean, default: false
    add_reference :orders, :technician, foreign_key: { to_table: :users }
  end
end
