class AddSupplierToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :supplier, polymorphic: true
  end
end
