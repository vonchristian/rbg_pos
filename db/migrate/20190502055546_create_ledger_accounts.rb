class CreateLedgerAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :ledger_accounts do |t|
      t.references :ledgerable, polymorphic: true
      t.belongs_to :account, foreign_key: true

      t.timestamps
    end
  end
end
