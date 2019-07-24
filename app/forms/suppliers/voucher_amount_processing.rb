module Suppliers
  class VoucherAmountProcessing
    include ActiveModel::Model
    attr_accessor :account_id, :amount, :amount_type, :supplier_id, :cart_id
    validates :account_id, :amount, :amount_type, :cart_id, presence: true
    def process!
      ActiveRecord::Base.transaction do
        create_voucher_amount
      end
    end

    private
    def create_voucher_amount
      find_cart.voucher_amounts.create!(
      account_id:          account_id,
      amount:              amount,
      amount_type:         amount_type)
    end

    def find_cart
      Cart.find(cart_id)
    end
  end
end
