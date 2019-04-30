require 'rails_helper'

module AccountingModule
  describe SubAccount do
    describe 'associations' do
      it { is_expected.to belong_to :main_account }
      it { is_expected.to belong_to :sub_account }
    end
  end
end
