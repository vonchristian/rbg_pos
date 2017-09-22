class CreateWorkOrderServiceCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :work_order_service_charges do |t|
      t.belongs_to :service_charge, foreign_key: true
      t.belongs_to :work_order, foreign_key: true

      t.timestamps
    end
  end
end
