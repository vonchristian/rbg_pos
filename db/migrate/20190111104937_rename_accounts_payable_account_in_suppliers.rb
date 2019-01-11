class RenameAccountsPayableAccountInSuppliers < ActiveRecord::Migration[5.1]
  def change
    rename_column :suppliers, :accounts_payable_account_id, :payable_account_id

  end
end
