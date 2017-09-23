class RemoveTechnicianFromWorkOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :work_orders, :technician, foreign_key: { to_table: :users }
  end
end
