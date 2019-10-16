class CreateParentAccountCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :parent_account_categories do |t|
      t.string :title
      t.string :account_code
      t.string :type
      t.belongs_to :business, null: false, foreign_key: true
      t.boolean :contra, default: false

      t.timestamps
    end
    add_index :parent_account_categories, :type
  end
end
