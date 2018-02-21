require 'rails_helper'

describe StoreFront do
  describe 'associations' do
    it { is_expected.to belong_to :business }
    it { is_expected.to belong_to :merchandise_inventory_account }
  end
end
