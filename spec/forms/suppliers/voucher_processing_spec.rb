require 'rails_helper'

module Suppliers
  describe VoucherProcessing, type: :model do
    describe 'validations' do
      it { is_expected.to validate_presence_of :date }
      it { is_expected.to validate_presence_of :description }
      it { is_expected.to validate_presence_of :reference_number }
      it { is_expected.to validate_presence_of :supplier_id }
      it { is_expected.to validate_presence_of :preparer_id }
      it { is_expected.to validate_presence_of :cart_id }
      it { is_expected.to validate_presence_of :account_number }



    end

    it '#process!' do
      account_number = '82dd7893-19bd-4a51-99af-e291e5145828'
      cart           = create(:cart)
      supplier       = create(:supplier)
      proprietor     = create(:proprietor)
      voucher_amount = create(:voucher_amount, amount_type: 'debit', amount: 100, cart: cart)
      voucher_amount = create(:voucher_amount, amount_type: 'credit', amount: 100, cart: cart)

      described_class.new(
        cart_id:          cart.id,
        supplier_id:      supplier.id,
        preparer_id:      proprietor.id,
        description:      'payment of stocks',
        date:             Date.current,
        account_number:   account_number,
        reference_number: '12312'
      ).process!
      expect(Voucher.find_by(account_number: account_number)).to_not eql nil
    end
  end
end
