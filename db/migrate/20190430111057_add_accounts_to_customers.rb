class AddAccountsToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_reference :customers, :service_revenue_account, foreign_key: { to_table: :accounts }
    add_reference :customers, :sales_revenue_account, foreign_key: { to_table: :accounts }
    add_reference :customers, :sales_discount_account, foreign_key: { to_table: :accounts }
  end
end
