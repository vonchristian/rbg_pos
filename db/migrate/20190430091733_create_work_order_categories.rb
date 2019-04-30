class CreateWorkOrderCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :work_order_categories do |t|
      t.string :title

      t.timestamps
    end
    add_index :work_order_categories, :title, unique: true
  end
end
