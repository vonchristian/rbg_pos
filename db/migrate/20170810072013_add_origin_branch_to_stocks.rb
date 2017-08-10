class AddOriginBranchToStocks < ActiveRecord::Migration[5.1]
  def change
    add_reference :stocks, :origin_branch, foreign_key: { to_table: :branches }
  end
end
