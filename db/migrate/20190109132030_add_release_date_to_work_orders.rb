class AddReleaseDateToWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :work_orders, :release_date, :datetime
  end
end
