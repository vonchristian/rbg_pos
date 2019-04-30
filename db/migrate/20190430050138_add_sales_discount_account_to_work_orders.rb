class AddSalesDiscountAccountToWorkOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :work_orders, :sales_discount_account, foreign_key: { to_table: :accounts }
    add_reference :work_orders, :service_revenue_account, foreign_key: { to_table: :accounts }
  end
end
