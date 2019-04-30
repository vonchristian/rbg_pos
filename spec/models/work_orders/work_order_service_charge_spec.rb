require 'rails_helper'

module WorkOrders
  describe WorkOrderServiceCharge  do
    describe 'associations' do
      it { is_expected.to belong_to :service_charge }
      it { is_expected.to belong_to :work_order }
      it { is_expected.to belong_to :user }
      it { is_expected.to have_many :amounts }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:description).to(:service_charge) }
      it { is_expected.to delegate_method(:amount).to(:service_charge) }
    end
  end
end
