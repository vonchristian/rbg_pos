class RemoveNameFromStocks < ActiveRecord::Migration[5.1]
  def change
    remove_index :stocks, :name
    remove_column :stocks, :name, :string
  end
end
