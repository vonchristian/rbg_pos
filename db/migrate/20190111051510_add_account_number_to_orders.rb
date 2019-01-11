class AddAccountNumberToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :account_number, :string
    add_index :orders, :account_number, unique: true
  end
end
