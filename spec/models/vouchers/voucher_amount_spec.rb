require 'rails_helper'

module Vouchers
  describe VoucherAmount do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :voucher }
      it { is_expected.to belong_to :commercial_document }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end
  end
end
