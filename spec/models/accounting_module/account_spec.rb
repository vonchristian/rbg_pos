require 'rails_helper'

module AccountingModule
  describe Account do
    describe 'associations' do
      it { is_expected.to belong_to :business }
      it { is_expected.to have_many :sub_accounts }
    end
  end
end
