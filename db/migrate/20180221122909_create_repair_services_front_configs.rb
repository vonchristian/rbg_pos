class CreateRepairServicesFrontConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :repair_services_front_configs do |t|
      t.belongs_to :accounts_receivable_account, foreign_key: { to_table: :accounts }, index: { name: 'index_accounts_receivable_account_on_repair_services_config'}
      t.belongs_to :repair_services_front, foreign_key: true

      t.timestamps
    end
  end
end
