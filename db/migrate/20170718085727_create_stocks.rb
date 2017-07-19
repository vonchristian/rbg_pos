class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.decimal :unit_cost
      t.belongs_to :product, foreign_key: true
      t.belongs_to :supplier, foreign_key: true
      t.decimal :total_cost
      t.decimal :quantity
      t.datetime :date
      t.string :barcode
      t.integer :mode_of_payment

      t.timestamps
    end
  end
end
