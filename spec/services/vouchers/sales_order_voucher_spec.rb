require 'rails_helper'

module Vouchers
  describe SalesOrderVoucher do
    it "#create_voucher! " do
      cash_on_hand = create(:asset)
      business     = create(:business)
      store_front  = create(:store_front, business: business)
      employee     = create(:employee, business: business, store_front: store_front, cash_on_hand_account: cash_on_hand)
      order        = create(:sales_order, store_front: store_front, employee: employee)

      described_class.new(order: order, employee: employee).create_voucher!

      expect(order.voucher).to_not be nil
    end
  end
end
