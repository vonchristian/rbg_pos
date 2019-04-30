require 'rails_helper'

describe WorkOrderCategory do
  describe 'associations' do
    it { is_expected.to have_many :work_orders }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_uniqueness_of :title }
  end 
end
