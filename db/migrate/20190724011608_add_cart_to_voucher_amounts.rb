class AddCartToVoucherAmounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :voucher_amounts, :cart, foreign_key: true
  end
end
