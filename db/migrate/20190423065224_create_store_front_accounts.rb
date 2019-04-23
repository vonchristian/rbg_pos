class CreateStoreFrontAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :store_front_accounts do |t|
      t.belongs_to :store_front, foreign_key: true
      t.belongs_to :account, foreign_key: true

      t.timestamps
    end
  end
end
