class AddWorkOrderIdToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :work_order, foreign_key: true
  end
end
