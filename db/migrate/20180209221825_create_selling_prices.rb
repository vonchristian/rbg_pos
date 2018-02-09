class CreateSellingPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :selling_prices do |t|
      t.decimal :price
      t.belongs_to :unit_of_measurement
      t.belongs_to :product
      t.datetime :date

      t.timestamps
    end
  end
end
