require 'rails_helper'

module Vouchers
  describe PurchaseOrderVoucher do
    it "#create_voucher!" do
      cash_on_hand_account = create(:asset)
      business = create(:business)
      store_front = create(:store_front, business: business)
      employee = create(:employee, business: business, store_front: store_front, cash_on_hand_account: cash_on_hand_account)
      order = create(:purchase_order, employee: employee, store_front: store_front)

      described_class.new(order: order, cash_account: cash_on_hand_account).create_voucher!

      expect(order.voucher).to_not be nil
    end

    it 'applicable_account' do
      business = create(:business)
      supplier = create(:supplier)
      cash_account = create(:asset)
      store_front = create(:store_front, business: business)
      order = create(:purchase_order, credit: false, store_front: store_front)
      credit_order = create(:purchase_order, credit: true, store_front: store_front, commercial_document: supplier)

      expect(described_class.new(order: order, cash_account: cash_account).applicable_account).to eql cash_account
      expect(described_class.new(order: credit_order, cash_account: nil).applicable_account).to eql supplier.payable_account


    end
  end
end
