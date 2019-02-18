class CreateEmployeeCashAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :employee_cash_accounts do |t|
      t.belongs_to :employee, foreign_key: { to_table: :users }
      t.belongs_to :cash_account, foreign_key: { to_table: :accounts }

      t.timestamps
    end
  end
end
