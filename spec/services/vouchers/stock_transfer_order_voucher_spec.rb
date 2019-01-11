require 'rails_helper'

module Vouchers
  describe StockTransferOrderVoucher do
    it "create_voucher!" do
      business                = create(:business)
      store_front             = create(:store_front, business: business)
      destination_store_front = create(:store_front, business: business)
      employee                = create(:user, business: business, store_front: store_front)

      order   = create(:stock_transfer_order, store_front: store_front, destination_store_front: destination_store_front)
      order_2 = create(:stock_transfer_order, store_front: store_front, destination_store_front: destination_store_front)

      described_class.new(order: order, employee: employee).create_voucher!

      expect(order.voucher).to_not be nil
      expect(order_2.voucher).to be nil

    end
  end
end
