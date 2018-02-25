class RemoveCustomerFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :orders, :customer, foreign_key: true
  end
end
