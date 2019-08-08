require 'rails_helper'

describe Accessory do
  describe 'associations' do
    it { is_expected.to belong_to :product_unit }
    it { is_expected.to belong_to :work_order }
  end 
end
