class AddNameFromStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :name, :string
  end
end
