class AddSalesRevenueAccountToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :sales_revenue_account, foreign_key: { to_table: :accounts }
  end
end
