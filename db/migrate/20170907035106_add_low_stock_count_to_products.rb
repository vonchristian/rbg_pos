class AddLowStockCountToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :low_stock_count, :decimal, default: 0
  end
end
