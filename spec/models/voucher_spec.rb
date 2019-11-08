require 'rails_helper'

describe Voucher do
  describe 'associations' do
    it { is_expected.to belong_to :payee }
    it { is_expected.to belong_to(:preparer).optional }
    it { is_expected.to belong_to(:commercial_document).optional }
    it { is_expected.to belong_to(:entry).optional }
    it { is_expected.to have_many :voucher_amounts }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :account_number }
    it { is_expected.to validate_uniqueness_of :account_number }
  end
  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:preparer).with_prefix }
    it { is_expected.to delegate_method(:name).to(:payee).with_prefix }
  end

  it "#disbursed?" do
    entry     = create(:entry_with_credit_and_debit)
    voucher   = create(:voucher, entry: entry)
    voucher_2 = create(:voucher, entry_id: nil)

    expect(voucher.disbursed?).to eql true
    expect(voucher_2.disbursed?).to eql false

  end
end
