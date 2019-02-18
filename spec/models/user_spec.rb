require 'rails_helper'

describe User do
  describe 'associations' do
    it { is_expected.to have_many :employee_cash_accounts }
    it { is_expected.to have_many :cash_accounts }
  end
end
