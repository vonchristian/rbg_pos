class AddProductNameAndCustomerNameToWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :work_orders, :customer_name, :string
    add_column :work_orders, :product_name, :string
  end
end
