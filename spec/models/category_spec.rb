require 'rails_helper'

describe Category do
  describe 'associations' do
    it { is_expected.to have_many :products }
  end 
end
