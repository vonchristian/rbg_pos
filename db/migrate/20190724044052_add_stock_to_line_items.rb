class AddStockToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :line_items, :stock, foreign_key: true
  end
end
