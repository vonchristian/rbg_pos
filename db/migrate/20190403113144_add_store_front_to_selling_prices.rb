class AddStoreFrontToSellingPrices < ActiveRecord::Migration[5.1]
  def change
    add_reference :selling_prices, :store_front, foreign_key: true
  end
end
