class AddServiceNumberToProductUnits < ActiveRecord::Migration[5.1]
  def change
    add_column :product_units, :service_number, :string
  end
end
