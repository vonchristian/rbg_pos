class AddServiceNumberToWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :work_orders, :service_number, :string
  end
end
