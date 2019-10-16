class AddServiceRevenueParentAccountCategoryToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_reference :businesses, :service_revenue_parent_account_category, foreign_key: { to_table: :parent_account_categories }
    add_reference :businesses, :sales_revenue_parent_account_category, foreign_key: { to_table: :parent_account_categories }
    add_reference :businesses, :service_receivable_parent_account_category, foreign_key: { to_table: :parent_account_categories }, index: { name: 'index_service_receivable_parent_account_category_on_businesses' }
  end
end
