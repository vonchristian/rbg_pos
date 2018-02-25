class RemoveMarkupAmountFromLineItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :line_items, :markup_amount, :decimal
  end
end
