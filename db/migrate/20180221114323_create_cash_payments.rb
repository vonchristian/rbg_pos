class CreateCashPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :cash_payments do |t|
      t.decimal :cash_tendered
      t.decimal :cash_change
      t.references :cash_paymentable, polymorphic: true, index: { name: 'index_paymentable_on_cash_payments' }

      t.timestamps
    end
  end
end
