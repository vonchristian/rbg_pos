require 'rails_helper'

describe Section do
  describe 'associations' do
    it { is_expected.to have_many :users }
    it { is_expected.to have_many :work_orders }
  end 
end
