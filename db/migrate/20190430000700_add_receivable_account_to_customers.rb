class AddReceivableAccountToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_reference :customers, :receivable_account, foreign_key: { to_table: :accounts }
  end
end
