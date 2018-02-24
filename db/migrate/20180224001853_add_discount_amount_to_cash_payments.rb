class AddDiscountAmountToCashPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :cash_payments, :discount_amount, :decimal
  end
end
