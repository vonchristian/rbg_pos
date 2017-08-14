class AddQuantityToWarrantyReleases < ActiveRecord::Migration[5.1]
  def change
    add_column :warranty_releases, :quantity, :decimal
  end
end
