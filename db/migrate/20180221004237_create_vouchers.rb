class CreateVouchers < ActiveRecord::Migration[5.1]
  def change
    create_table :vouchers do |t|
      t.datetime :date
      t.references :payee, polymorphic: true
      t.string :description
      t.decimal :payable_amount
      t.string :type
      t.belongs_to :preparer, foreign_key: { to_table: :users }
      t.belongs_to :disburser, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :vouchers, :type
  end
end
