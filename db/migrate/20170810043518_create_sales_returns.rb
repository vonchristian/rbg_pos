class CreateSalesReturns < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_returns do |t|
      t.belongs_to :line_item, foreign_key: true
      t.integer :sales_return_type
      t.datetime :date
      t.string :remarks
      t.belongs_to :order, foreign_key: true
      t.decimal :quantity
      t.string :name
      t.string :barcode

      t.timestamps
    end
    add_index :sales_returns, :sales_return_type
  end
end
