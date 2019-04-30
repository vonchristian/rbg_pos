class RemoveMainAccountFromAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :accounts, :main_account, foreign_key: { to_table: :accounts }
  end
end
