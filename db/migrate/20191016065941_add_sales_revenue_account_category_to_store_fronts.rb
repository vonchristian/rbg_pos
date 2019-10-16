class AddSalesRevenueAccountCategoryToStoreFronts < ActiveRecord::Migration[6.0]
  def change
    add_reference :store_fronts, :sales_revenue_account_category, foreign_key: { to_table: :account_categories }
  end
end
