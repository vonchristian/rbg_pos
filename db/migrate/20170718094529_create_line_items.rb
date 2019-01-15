class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :line_items do |t|
      t.belongs_to :cart, foreign_key: true
      t.decimal :unit_cost
      t.decimal :total_cost
      t.decimal :quantity

      t.timestamps
    end
  end
end
