require 'rails_helper'

module Vouchers
  describe PurchaseReturnOrderVoucher do
    it '#create_voucher!' do
      business = create(:business)
      purchase_return_account = create(:expense)
      store_front = create(:store_front, business: business, purchase_return_account: purchase_return_account)
      order = create(:purchase_return_order, store_front: store_front)

      described_class.new(order: order).create_voucher!

      expect(order.voucher).to_not be nil 
    end
  end
end
