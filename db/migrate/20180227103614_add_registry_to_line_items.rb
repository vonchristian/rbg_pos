class AddRegistryToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :registry, foreign_key: true
  end
end
