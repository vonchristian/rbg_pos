class RemoveWorkOrderFromLineItems < ActiveRecord::Migration[5.1]
  def change
    remove_reference :line_items, :work_order, foreign_key: true
  end
end
