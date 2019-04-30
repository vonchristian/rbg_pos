class AddSalesDiscountAccountToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :sales_discount_account, foreign_key: { to_table: :accounts }
  end
end
