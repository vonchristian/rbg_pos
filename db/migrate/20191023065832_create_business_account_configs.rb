class CreateBusinessAccountConfigs < ActiveRecord::Migration[6.0]
  def change
    create_table :business_account_configs do |t|
      t.belongs_to :business, null: false, foreign_key: true
      t.belongs_to :service_receivable_category, null: false, foreign_key: { to_table: :parent_account_categories }, index: { name: 'index_service_rec_categories_on_business_configs' }
      t.belongs_to :service_revenue_category, null: false, foreign_key: { to_table: :parent_account_categories }, index: { name: 'index_service_rev_categories_on_business_configs' }
      t.belongs_to :sales_receivable_category, null: false, foreign_key: { to_table: :parent_account_categories }, index: { name: 'index_sales_rec_categories_on_business_configs' }
      t.belongs_to :sales_revenue_category, null: false, foreign_key: { to_table: :parent_account_categories }, index: { name: 'index_sales_rev_categories_on_business_configs' }

      t.timestamps
    end
  end
end
