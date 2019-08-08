require 'rails_helper'
module StoreFrontModule
  describe CashPayment, type: :model do
    describe 'associations' do
      it { is_expected.to belong_to :cash_paymentable }
    end 
  end
end
