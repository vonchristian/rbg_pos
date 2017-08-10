class AddStockTypeToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :stock_type, :integer
    add_index :stocks, :stock_type
  end
end
