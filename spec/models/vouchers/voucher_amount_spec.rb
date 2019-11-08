require 'rails_helper'

module Vouchers
  describe VoucherAmount do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to(:voucher).optional }
      it { is_expected.to belong_to(:cart).optional }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end

    it { is_expected.to define_enum_for(:amount_type).with_values([:debit, :credit]) }

    it ".without_voucher" do
      voucher          = create(:voucher)
      voucher_amount_1 = create(:voucher_amount, voucher_id: nil)
      voucher_amount_2 = create(:voucher_amount, voucher: voucher)

      expect(described_class.without_voucher).to include(voucher_amount_1)
      expect(described_class.without_voucher).to_not include(voucher_amount_2)
    end

    it '.total' do
      amount_1 = create(:voucher_amount, amount: 100)
      amount_2 = create(:voucher_amount, amount: 100)

      expect(described_class.total).to eql 200
    end
  end
end
