class AddEmployeeIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :employee, foreign_key: { to_table: :users }
  end
end
