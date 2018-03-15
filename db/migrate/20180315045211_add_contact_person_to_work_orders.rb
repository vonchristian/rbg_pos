class AddContactPersonToWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :work_orders, :contact_person, :string
  end
end
