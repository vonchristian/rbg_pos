class AddAccountNumberToWorkOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :work_orders, :account_number, :string
    add_index :work_orders, :account_number, unique: true
  end
end
