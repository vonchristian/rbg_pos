class AddStoreFrontToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :store_front, foreign_key: true
  end
end
