class CreateLevelOneAccountCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :level_one_account_categories do |t|
      t.string :title
      t.string :code
      t.string :type
      t.belongs_to :store_front, null: false, foreign_key: true
      t.boolean :contra, default: false 

      t.timestamps
    end
    add_index :level_one_account_categories, :type
  end
end
