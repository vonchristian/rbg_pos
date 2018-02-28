class CreateBankAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_accounts do |t|
      t.string :account_number
      t.string :bank_name
      t.belongs_to :cash_in_bank_account, foreign_key: { to_table: :accounts }
      t.belongs_to :business, foreign_key: true
      t.datetime :date

      t.timestamps
    end
  end
end
