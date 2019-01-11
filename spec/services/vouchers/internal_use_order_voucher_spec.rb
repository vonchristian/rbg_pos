require 'rails_helper'

module Vouchers
  describe InternalUseOrderVoucher do
    it "#create_voucher" do
      business = create(:business)
      internal_use_account = create(:expense)
      employee = create(:user, business: business)
      store_front = create(:store_front, business: business, internal_use_account: internal_use_account)

      order = create(:internal_use_order, store_front: store_front, employee: employee)

      described_class.new(order: order).create_voucher!

      expect(order.voucher).to_not be nil
    end
  end
end
