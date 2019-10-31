class AddAvailableQuantityToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :available_quantity, :decimal, default: 0
  end
end
