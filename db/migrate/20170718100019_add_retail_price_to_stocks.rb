class AddRetailPriceToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :retail_price, :decimal
    add_column :stocks, :wholesale_price, :decimal
  end
end
