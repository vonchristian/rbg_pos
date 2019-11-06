require 'rails_helper'

module WorkOrders
  describe ServiceChargeCancellation do
    it 'cancel!' do
      user = create(:sales_clerk)
      work_order     = create(:work_order)
      service_charge = create(:service_charge)
      charge         = work_order.work_order_service_charges.create!(service_charge: service_charge, user: user)
      entry = build(:entry_with_credit_and_debit)
      entry.debit_amounts.build(amount: 100, account: work_order.service_revenue_account)
      entry.credit_amounts.build(amount: 100, account: work_order.receivable_account)
      entry.save!
      described_class.new(service_charge: charge).cancel!

      expect(work_order.service_charges.pluck(:id)).to_not include(service_charge.id)

    end
  end
end
