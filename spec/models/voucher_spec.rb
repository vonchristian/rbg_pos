require 'rails_helper'

describe Voucher, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :payee }
    it { is_expected.to belong_to :preparer }
    it { is_expected.to belong_to :disburser }
    it { is_expected.to have_one :entry }
    it { is_expected.to have_many :voucher_amounts }
  end
  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:preparer).with_prefix }
    it { is_expected.to delegate_method(:name).to(:disburser).with_prefix }
  end
  it "#disbursed?" do
    #TODO
  end
end
