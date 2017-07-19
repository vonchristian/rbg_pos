class AddAvatarToProducts < ActiveRecord::Migration[5.1]
  def up
    add_attachment :products, :avatar
  end
  def down
    remove_attachment :products, :avatar
  end
end
