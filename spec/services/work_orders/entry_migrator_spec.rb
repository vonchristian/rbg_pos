require 'rails_helper'

module WorkOrders
  describe EntryMigrator do
    it 'migrate_service_charge_entries!' do
      receivable_account_1 = create(:asset)
      receivable_account_2 = create(:asset)
      store_front          = create(:store_front, receivable_account: receivable_account_1)
      work_order           = create(:work_order, receivable_account: receivable_account_2, store_front: store_front)
      service_charge       = work_order.service_charges.create(amount: 100)
      entry                = build(:entry_with_credit_and_debit)
      entry.debit_amounts.build(amount: 100, account: receivable_account_1, commercial_document: service_charge)
      entry.credit_amounts.build(amount: 100, account: store_front.service_revenue_account, commercial_document: service_charge)
      entry.save!

      expect(receivable_account_1.balance).to eql 100
      expect(receivable_account_2.balance).to eql 0

      described_class.new(work_order: work_order).migrate_service_charge_entries!

      expect(receivable_account_1.balance).to eql 0
      expect(receivable_account_2.balance).to eql 100
    end

    it 'migrate_spare_part_entries!' do
      receivable_account_1 = create(:asset)
      receivable_account_2 = create(:asset)
      store_front          = create(:store_front, receivable_account: receivable_account_1)
      work_order           = create(:work_order, receivable_account: receivable_account_2, store_front: store_front)

      entry                = build(:entry_with_credit_and_debit)
      entry.debit_amounts.build(amount: 100, account: receivable_account_1, commercial_document: work_order)
      entry.credit_amounts.build(amount: 100, account: store_front.sales_revenue_account, commercial_document: work_order)
      entry.save!

      expect(receivable_account_1.balance).to eql 100
      expect(receivable_account_2.balance).to eql 0

      described_class.new(work_order: work_order).migrate_spare_part_entries!

      expect(receivable_account_1.balance).to eql 0
      expect(receivable_account_2.balance).to eql 100
    end
  end
end
