require 'rails_helper'

describe StoreFront do
  describe 'associations' do
    it { is_expected.to belong_to :business }
    it { is_expected.to belong_to :merchandise_inventory_account }
    it { is_expected.to belong_to :receivable_account }
    it { is_expected.to belong_to :internal_use_account }
    it { is_expected.to belong_to :purchase_return_account }

  end
end
