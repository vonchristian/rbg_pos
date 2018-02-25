class RemoveBarcodeFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :barcode, :string
  end
end
