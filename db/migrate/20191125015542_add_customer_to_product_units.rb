class AddCustomerToProductUnits < ActiveRecord::Migration[6.0]
  def change
    add_reference :product_units, :customer, foreign_key: true
  end
end
