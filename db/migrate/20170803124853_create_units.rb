class CreateUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :units do |t|
      t.string :brand
      t.string :model
      t.string :serial_number
      t.datetime :purchase_date
      t.datetime :warranty_date
      t.belongs_to :customer, foreign_key: true

      t.timestamps
    end
  end
end
