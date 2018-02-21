class CreateStoreFrontConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :store_front_configs do |t|
      t.belongs_to :accounts_receivable_account, foreign_key: { to_table: :accounts }
      t.belongs_to :store_front, foreign_key: true

      t.timestamps
    end
  end
end
