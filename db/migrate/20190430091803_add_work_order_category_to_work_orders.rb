class AddWorkOrderCategoryToWorkOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :work_orders, :work_order_category, foreign_key: true
  end
end
