require 'rails_helper'

module StoreFronts
  module Orders
    describe PurchaseOrder, type: :model do
      describe 'associations' do
        it { is_expected.to belong_to :supplier }
        it { is_expected.to belong_to :store_front }
        it { is_expected.to belong_to :employee }
        it { is_expected.to belong_to :voucher }
        it { is_expected.to belong_to :receivable_account }

      end

      describe 'validations' do
        it { is_expected.to validate_presence_of :date }
        it { is_expected.to validate_presence_of :account_number }
        it  'validate_uniqueness_of_account_number' do
          purchase_order = create(:purchase_order, account_number: '1010')
          rep = build(:purchase_order, account_number: '1010')
          rep.save
          expect(rep.errors[:account_number]).to eql(['has already been taken'])

        end
      end
    end
  end
end
