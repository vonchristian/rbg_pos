class AddBusinessToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :business, foreign_key: true
  end
end
