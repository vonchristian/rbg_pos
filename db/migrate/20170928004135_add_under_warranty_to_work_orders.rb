class AddUnderWarrantyToWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column  :work_orders, :under_warranty, :boolean, default: false
    add_column  :work_orders, :supplier_id, :integer, foreign_key: true, index: true 
    add_column  :work_orders, :purchase_date, :datetime 
    add_column  :work_orders, :expiry_date, :datetime
  end
end
