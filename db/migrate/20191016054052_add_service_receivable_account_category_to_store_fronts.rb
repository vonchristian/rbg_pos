class AddServiceReceivableAccountCategoryToStoreFronts < ActiveRecord::Migration[6.0]
  def change
    add_reference :store_fronts, :service_receivable_account_category, foreign_key: { to_table: :account_categories }
  end
end
