class CreateSubAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_accounts do |t|
      t.belongs_to :main_account, foreign_key: { to_table: :accounts }
      t.belongs_to :sub_account, foreign_key: { to_table: :accounts }

      t.timestamps
    end
  end
end
