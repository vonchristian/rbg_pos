class AddReceivableBalanceToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :receivable_balance, :decimal, default: 0
    add_index :customers, :receivable_balance
  end
end
