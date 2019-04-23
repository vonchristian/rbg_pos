require 'rails_helper'

module StoreFronts
  describe StoreFrontAccount do
    describe 'associations' do
      it { is_expected.to belong_to :store_front }
      it { is_expected.to belong_to :employee }
    end
    describe 'validations' do
    end
  end
end
