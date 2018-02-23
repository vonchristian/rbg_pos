class AddStoreFrontToWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :work_orders, :store_front, foreign_key: true
  end
end
