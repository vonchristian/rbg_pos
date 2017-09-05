class CreateProductUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :product_units do |t|
      t.string :description
      t.string :model_number
      t.string :serial_number
      t.text :physical_condition
      t.text :reported_problem

      t.timestamps
    end
  end
end
