class AddDateReceivedToWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :work_orders, :date_received, :datetime
  end
end
