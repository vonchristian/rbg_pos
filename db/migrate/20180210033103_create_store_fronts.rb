class CreateStoreFronts < ActiveRecord::Migration[5.1]
  def change
    create_table :store_fronts do |t|
      t.belongs_to :business, foreign_key: true
      t.belongs_to :merchandise_inventory_account, foreign_key: { to_table: :accounts }
      t.string :name

      t.timestamps
    end
    add_index :store_fronts, :name, unique: true
  end
end
