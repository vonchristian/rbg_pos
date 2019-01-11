require 'rails_helper'

module Vouchers
  describe SalesReturnOrderVoucher do
    it "#create_voucher! " do
      cash_account = create(:asset)
      business     = create(:business)
      store_front  = create(:store_front, business: business)
      employee     = create(:employee, business: business, store_front: store_front, cash_on_hand_account: cash_account)
      order        = create(:sales_return_order, store_front: store_front, employee: employee)

      described_class.new(order: order, cash_account: cash_account).create_voucher!

      expect(order.voucher).to_not be nil
    end

    it "#applicable_account" do
      cash_account = create(:asset)
      receivable_account = create(:asset)
      business     = create(:business)
      store_front  = create(:store_front, business: business, receivable_account: receivable_account)
      employee     = create(:employee, business: business, store_front: store_front, cash_on_hand_account: cash_account)
      credit_order = create(:sales_return_order, store_front: store_front, employee: employee, credit: true)
      cash_order   = create(:sales_return_order, store_front: store_front, employee: employee, credit: false)

      expect(described_class.new(order: credit_order, cash_account: nil).applicable_account).to eq receivable_account
      expect(described_class.new(order: cash_order, cash_account: cash_account).applicable_account).to eql cash_account

    end
  end
end
