class AddReferencerToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :referencer, polymorphic: true
  end
end
