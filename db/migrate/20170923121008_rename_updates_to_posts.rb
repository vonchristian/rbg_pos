class RenameUpdatesToPosts < ActiveRecord::Migration[5.1]
  def change
    remove_index :updates, :type
    rename_table :updates, :posts 
    add_index :posts, :type
  end
end
