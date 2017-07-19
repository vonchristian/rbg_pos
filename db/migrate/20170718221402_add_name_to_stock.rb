class AddNameToStock < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :name, :string
    add_index :stocks, :name, unique: true
  end
end
