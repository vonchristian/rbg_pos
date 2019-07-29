require 'rails_helper'

module Suppliers
  describe VoucherAggregator do
    it 'unused_vouchers' do
      supplier       = create(:supplier)
      entry_1        = create(:entry_with_credit_and_debit)
      voucher_1      = create(:voucher, entry: entry_1, payee: supplier)
      entry_2        = create(:entry_with_credit_and_debit)
      voucher_2      = create(:voucher, entry: entry_2, payee: supplier)
      purchase_order = create(:purchase_order, supplier: supplier, voucher: voucher_1)

      expect(supplier.vouchers).to include(voucher_1)
      expect(supplier.vouchers).to include(voucher_2)
      expect(supplier.purchase_orders).to include(purchase_order)
      expect(described_class.new(supplier: supplier).unused_vouchers.ids).to include(voucher_2.id)
      expect(described_class.new(supplier: supplier).unused_vouchers.ids).to_not include(voucher_1.id)
    end
  end
end
