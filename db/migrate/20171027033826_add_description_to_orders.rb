class AddDescriptionToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :description, :string
  end
end
