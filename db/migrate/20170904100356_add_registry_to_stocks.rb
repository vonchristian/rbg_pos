class AddRegistryToStocks < ActiveRecord::Migration[5.1]
  def change
    add_reference :stocks, :registry, foreign_key: true
  end
end
