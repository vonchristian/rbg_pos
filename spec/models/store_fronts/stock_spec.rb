require 'rails_helper'

module StoreFronts
  describe Stock do
    describe 'associations' do
      it { is_expected.to belong_to :product }
    end 
  end
end
