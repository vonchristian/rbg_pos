require 'rails_helper'

RSpec.describe ProductUnit, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :repairs }
    it { is_expected.to have_many :accessories }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :description }
  end 
end
