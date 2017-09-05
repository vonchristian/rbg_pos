class CreateProductUnitServiceCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :product_unit_service_charges do |t|
      t.belongs_to :product_unit, foreign_key: true
      t.belongs_to :service_charge, foreign_key: true

      t.timestamps
    end
  end
end
