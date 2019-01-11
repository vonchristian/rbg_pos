require 'rails_helper'

module Vouchers
  describe SpoilageOrderVoucher do
    it '#create_voucher!' do
      spoilage_account = create(:expense)
      business     = create(:business)
      store_front  = create(:store_front, business: business, spoilage_account: spoilage_account)
      order        = create(:spoilage_order, store_front: store_front)

      described_class.new(order: order).create_voucher!

      expect(order.voucher).to_not be nil
    end
  end
end
