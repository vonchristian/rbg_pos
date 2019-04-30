class AddSalesRevenueAccountToWorkOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :work_orders, :sales_revenue_account, foreign_key: { to_table: :accounts }
  end
end
