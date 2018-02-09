class CreateUnitOfMeasurements < ActiveRecord::Migration[5.1]
  def change
    create_table :unit_of_measurements do |t|
      t.belongs_to :product, foreign_key: true
      t.string :unit_code
      t.string :description
      t.decimal :quantity
      t.decimal :conversion_quantity
      t.boolean :base_measurement, default: :false

      t.timestamps
    end
  end
end
