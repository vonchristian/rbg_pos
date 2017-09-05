class CreateAccessories < ActiveRecord::Migration[5.1]
  def change
    create_table :accessories do |t|
      t.belongs_to :product_unit, foreign_key: true
      t.decimal :quantity
      t.string :description
      t.string :serial_number

      t.timestamps
    end
  end
end
