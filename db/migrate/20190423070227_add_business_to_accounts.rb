class AddBusinessToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :business, foreign_key: true
  end
end
