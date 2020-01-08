class AddTechnicianToWorkOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :work_orders, :technician, foreign_key: { to_table: :users }
  end
end
