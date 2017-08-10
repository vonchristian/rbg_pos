class AddBranchToStocks < ActiveRecord::Migration[5.1]
  def change
    add_reference :stocks, :branch, foreign_key: true
  end
end
