class RemoveTechnicianFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :orders, :technician, foreign_key: { to_table: :users }
  end
end
