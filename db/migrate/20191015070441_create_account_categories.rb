class CreateAccountCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :account_categories do |t|
      t.string :title
      t.string :account_code
      t.string :type
      t.boolean :contra, default: false
      t.belongs_to :business, null: false, foreign_key: true

      t.timestamps
    end
    add_index :account_categories, :type
  end
end
