class AddAddressToStoreFronts < ActiveRecord::Migration[5.1]
  def change
    add_column :store_fronts, :address, :string
  end
end
