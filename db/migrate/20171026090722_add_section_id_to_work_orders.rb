class AddSectionIdToWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :work_orders, :section, foreign_key: true
  end
end
