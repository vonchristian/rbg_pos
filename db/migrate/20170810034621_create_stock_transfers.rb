class CreateStockTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_transfers do |t|
      t.belongs_to :stock, foreign_key: true
      t.datetime :date
      t.decimal :quantity
      t.belongs_to :destination_branch, foreign_key: { to_table: :branches }
      t.belongs_to :origin_branch, foreign_key: { to_table: :branches }

      t.timestamps
    end
  end
end
