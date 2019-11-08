require 'rails_helper'

describe BankAccount, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :cash_in_bank_account }
  end 
end
