require 'rails_helper'

module AccountingModule
  describe Amount do
    describe 'associations' do
      it { is_expected.to belong_to :entry }
      it { is_expected.to belong_to :account }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :type }
      it { is_expected.to validate_presence_of :amount }
    end
  end
end
