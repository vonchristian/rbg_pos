class AddEmployeeToStocks < ActiveRecord::Migration[5.1]
  def change
    add_reference :stocks, :employee, foreign_key: { to_table: :users }
  end
end
