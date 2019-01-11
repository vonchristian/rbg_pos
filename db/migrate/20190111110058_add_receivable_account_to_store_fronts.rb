class AddReceivableAccountToStoreFronts < ActiveRecord::Migration[5.1]
  def change
    add_reference :store_fronts, :receivable_account, foreign_key: { to_table: :accounts }
  end
end
