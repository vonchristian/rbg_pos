class AddBranchToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :branch, foreign_key: true
  end
end
