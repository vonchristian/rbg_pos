class AddDestinationStoreFrontToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :destination_store_front, foreign_key: { to_table: :store_fronts }
  end
end
