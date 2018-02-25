class RemoveStockIdFromLineItems < ActiveRecord::Migration[5.1]
  def change
    remove_reference :line_items, :stock, foreign_key: true
  end
end
