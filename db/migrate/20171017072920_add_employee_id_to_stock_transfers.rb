class AddEmployeeIdToStockTransfers < ActiveRecord::Migration[5.1]
  def change
    add_reference :stock_transfers, :employee, foreign_key: { to_table: :users }
  end
end
