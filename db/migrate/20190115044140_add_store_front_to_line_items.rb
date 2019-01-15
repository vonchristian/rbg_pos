class AddStoreFrontToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :store_front, foreign_key: true
  end
end
