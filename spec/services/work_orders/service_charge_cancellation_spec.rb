require 'rails_helper'

module WorkOrders
  describe ServiceChargeCancellation do
    it 'cancel!' do
      work_order     = create(:work_order)
      service_charge = work_order.service_charges.create(amount: 100)
      entry = build(:entry_with_credit_and_debit)
      entry.debit_amounts.build(amount: 100, account: work_order.default_service_revenue_account, commercial_document: service_charge)
      entry.credit_amounts.build(amount: 100, account: work_order.default_receivable_account, commercial_document: service_charge)
      entry.save!
      described_class.new(service_charge: service_charge, work_order: work_order).cancel!

      expect(work_order.service_charges.pluck(:id)).to_not include(service_charge.id)
      expect(AccountingModule::Entry.pluck(:id)).to_not include(entry)
    end
  end
end
