class CreateWarranties < ActiveRecord::Migration[5.1]
  def change
    create_table :warranties do |t|
    	t.string :barcode 
    	t.string :name
    	t.string :remarks
    	t.decimal :quantity
      t.belongs_to :sales_return, foreign_key: true
      t.belongs_to :supplier, foreign_key: true
      t.belongs_to :customer, foreign_key: true

      t.datetime :date

      t.timestamps
    end
  end
end
