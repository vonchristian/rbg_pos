class CreateWorkOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :work_orders do |t|
      t.integer :status
      t.belongs_to :product_unit, foreign_key: true
      t.belongs_to :technician, foreign_key: { to_table: :users }
      t.belongs_to :customer, foreign_key: true

      t.timestamps
    end
    add_index :work_orders, :status
  end
end
