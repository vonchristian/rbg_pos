class RemoveModeOfPaymentFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :mode_of_payment, :integer
  end
end
