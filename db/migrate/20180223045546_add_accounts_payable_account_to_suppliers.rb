class AddAccountsPayableAccountToSuppliers < ActiveRecord::Migration[5.1]
  def change
    add_reference :suppliers, :accounts_payable_account, foreign_key: { to_table: :accounts }
  end
end
