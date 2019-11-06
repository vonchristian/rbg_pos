class CreatePurchaseOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_orders do |t|
      t.references :supplier, polymorphic: true, null: false
      t.belongs_to :voucher, null: false, foreign_key: true
      t.string :account_number, unique: true
      t.belongs_to :employee, null: false, foreign_key: { to_table: :users }
      t.belongs_to :store_front, null: false, foreign_key: true
      t.belongs_to :receivable_account, null: false, foreign_key: { to_table: :accounts }
      t.datetime :date


      t.timestamps
    end
  end
end
