class AddReferenceNumberToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :reference_number, :string
    add_index :orders, :reference_number
  end
end
