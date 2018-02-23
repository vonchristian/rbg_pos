class AddAccountsToStoreFronts < ActiveRecord::Migration[5.1]
  def change
    add_reference :store_fronts, :cost_of_goods_sold_account, foreign_key: { to_table: :accounts }
    add_reference :store_fronts, :sales_return_account, foreign_key: { to_table: :accounts }
    add_reference :store_fronts, :sales_account, foreign_key: { to_table: :accounts }
    add_reference :store_fronts, :sales_discount_account, foreign_key: { to_table: :accounts }

  end
end
