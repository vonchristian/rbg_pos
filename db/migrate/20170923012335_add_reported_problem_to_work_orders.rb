class AddReportedProblemToWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :work_orders, :reported_problem, :string
    add_column :work_orders, :physical_condition, :string
  end
end
