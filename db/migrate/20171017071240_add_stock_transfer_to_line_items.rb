class AddStockTransferToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :stock_transfer, foreign_key: true
  end
end
