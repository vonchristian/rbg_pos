class AddUserToWorkOrderServiceCharges < ActiveRecord::Migration[5.1]
  def change
    add_reference :work_order_service_charges, :user, foreign_key: true
  end
end
