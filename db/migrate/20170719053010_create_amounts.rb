class CreateAmounts < ActiveRecord::Migration[5.1]
  def change
    create_table :amounts do |t|
      t.belongs_to :account, foreign_key: true
      t.belongs_to :entry, foreign_key: true
      t.decimal :amount
      t.string :type

      t.timestamps
    end
    add_index :amounts, :type
    add_index :amounts, [:account_id, :entry_id]
    add_index :amounts, [:entry_id, :account_id]
  end
end
