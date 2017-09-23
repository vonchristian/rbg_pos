class CreateTechnicianWorkOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :technician_work_orders do |t|
      t.belongs_to :technician, foreign_key: { to_table: :users }
      t.belongs_to :work_order, foreign_key: true

      t.timestamps
    end
  end
end
