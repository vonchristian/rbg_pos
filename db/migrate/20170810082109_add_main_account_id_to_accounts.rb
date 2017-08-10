class AddMainAccountIdToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_reference :accounts, :main_account, foreign_key: { to_table: :accounts }
  end
end
