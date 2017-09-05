class CreateServiceCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :service_charges do |t|
      t.string :description
      t.decimal :amount

      t.timestamps
    end
  end
end
