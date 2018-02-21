class CreateVoucherAmounts < ActiveRecord::Migration[5.1]
  def change
    create_table :voucher_amounts do |t|
      t.decimal :amount
      t.belongs_to :account, foreign_key: true
      t.belongs_to :voucher, foreign_key: true
      t.references :commercial_document, polymorphic: true, index: { name: 'index_commercial_document_on_voucher_amounts' }
      t.string :description
      t.integer :amount_type

      t.timestamps
    end
    add_index :voucher_amounts, :amount_type
  end
end
