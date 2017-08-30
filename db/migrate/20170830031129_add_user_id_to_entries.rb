class AddUserIdToEntries < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :user, foreign_key: true
  end
end
