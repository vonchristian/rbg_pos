class AddPayableAccountToPurchaseOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :payable_account,  foreign_key: { to_table: :accounts }
  end
end
