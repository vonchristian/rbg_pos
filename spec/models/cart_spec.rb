require 'rails_helper'

describe Cart do
  describe 'associations' do
    it { is_expected.to have_many :voucher_amounts }
  end 
end
