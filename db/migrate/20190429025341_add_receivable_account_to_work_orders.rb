class AddReceivableAccountToWorkOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :work_orders, :receivable_account, foreign_key: { to_table: :accounts }
  end
end
