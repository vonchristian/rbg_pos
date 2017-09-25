class AddUserIdToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :user, foreign_key: true
  end
end
