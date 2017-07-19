class AddModeOfPaymentToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :mode_of_payment, :integer
    add_index :orders, :mode_of_payment
  end
end
