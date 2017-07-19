class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :unit
      t.decimal :retail_price
      t.decimal :wholesale_price

      t.timestamps
    end
    add_index :products, :name, unique: true
  end
end
