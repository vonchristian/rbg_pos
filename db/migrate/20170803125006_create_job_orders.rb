class CreateJobOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :job_orders do |t|
      t.belongs_to :unit, foreign_key: true
      t.datetime :date
      t.integer :status
      t.text :remarks
      t.integer :actions_taken
      t.belongs_to :customer, foreign_key: true

      t.timestamps
    end
    add_index :job_orders, :status
  end
end
