class AddDepartmentToWorkOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :work_orders, :department, foreign_key: true
  end
end
