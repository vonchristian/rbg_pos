class Add2PayableAccountToPurchaseOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :purchase_orders, :payable_account,  foreign_key: { to_table: :accounts }
  end
end
