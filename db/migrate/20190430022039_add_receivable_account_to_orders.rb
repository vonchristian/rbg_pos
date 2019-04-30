class AddReceivableAccountToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :receivable_account, foreign_key: { to_table: :accounts }
  end
end
