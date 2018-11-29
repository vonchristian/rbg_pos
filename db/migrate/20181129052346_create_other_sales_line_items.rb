class CreateOtherSalesLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :other_sales_line_items do |t|
      t.decimal :amount
      t.string :description
      t.string :reference_number
      t.datetime :date
      t.belongs_to :order, foreign_key: true
      t.belongs_to :cart, foreign_key: true


      t.timestamps
    end
  end
end
