require 'rails_helper'

module Orders
  describe Cancellation do
    it 'cancel!' do
      voucher = create(:voucher)
      order   = create(:purchase_order, voucher: voucher)
      entry   = create(:entry_with_credit_and_debit, commercial_document: voucher)

      Orders::Cancellation.new(order: order).cancel!

      expect(Voucher.pluck(:id)).to_not include(voucher.id)
      expect(AccountingModule::Entry.pluck(:id)).to_not include(entry.id)
      expect(Order.pluck(:id)).to_not include(order.id)
    end
  end
end
