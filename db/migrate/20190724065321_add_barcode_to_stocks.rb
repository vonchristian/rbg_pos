class AddBarcodeToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :barcode, :string
  end
end
