class AddMarkupAmountToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :markup_amount, :decimal, default: 0
  end
end
