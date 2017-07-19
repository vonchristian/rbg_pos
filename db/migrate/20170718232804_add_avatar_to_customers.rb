class AddAvatarToCustomers < ActiveRecord::Migration[5.1]
 def up
    add_attachment :customers, :avatar
  end
  def down
    remove_attachment :customers, :avatar
  end
end
