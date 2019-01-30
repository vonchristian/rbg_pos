class AddServiceRevenueAccountToStoreFront < ActiveRecord::Migration[5.1]
  def change
    add_reference :store_fronts, :service_revenue_account, foreign_key: { to_table: :accounts }
  end
end
