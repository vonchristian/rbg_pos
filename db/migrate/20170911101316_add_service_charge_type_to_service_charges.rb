class AddServiceChargeTypeToServiceCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :service_charges, :charge_type, :integer
    add_index :service_charges, :charge_type
  end
end
