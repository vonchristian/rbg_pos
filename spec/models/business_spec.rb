require 'rails_helper'

describe Business do
  describe 'associations' do
    it { is_expected.to have_many :customers }
    it { is_expected.to have_many :employees }
    it { is_expected.to have_many :store_fronts }
    it { is_expected.to have_many :accounts }
    it { is_expected.to have_many :work_orders }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
  end
end
