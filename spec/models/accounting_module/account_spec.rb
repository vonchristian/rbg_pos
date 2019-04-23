require 'rails_helper'

module AccountingModule
  describe Account do
    describe 'associations' do
      it { is_expected.to belong_to :business }
    end
  end
end
