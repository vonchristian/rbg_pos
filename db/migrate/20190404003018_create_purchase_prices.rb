class CreatePurchasePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_prices do |t|
      t.belongs_to :product, foreign_key: true
      t.belongs_to :unit_of_measurement, foreign_key: true
      t.belongs_to :store_front, foreign_key: true
      t.decimal :price
      t.datetime :date

      t.timestamps
    end
  end
end
