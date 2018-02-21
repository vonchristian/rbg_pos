require 'rails_helper'

module RepairServicesModule
  describe RepairServicesFront do
    describe 'associations' do
      it { is_expected.to belong_to :business }
    end
  end
end
