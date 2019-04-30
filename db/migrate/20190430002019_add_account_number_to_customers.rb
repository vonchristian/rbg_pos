class AddAccountNumberToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :account_number, :string
    add_index :customers, :account_number, unique: true
  end
end
