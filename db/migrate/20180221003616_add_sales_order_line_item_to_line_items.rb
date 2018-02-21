class AddSalesOrderLineItemToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :sales_order_line_item, foreign_key: { to_table: :line_items }
    add_reference :line_items, :purchase_order_line_item, foreign_key: { to_table: :line_items }
    add_column :line_items, :bar_code, :string
  end
end
