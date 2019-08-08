class AddAvailableToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :available, :boolean, default: false
  end
end
