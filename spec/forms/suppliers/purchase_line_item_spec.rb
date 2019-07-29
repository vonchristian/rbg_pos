require 'rails_helper'

module Suppliers
  describe PurchaseLineItem, type: :model do
    describe 'validations' do
      it { is_expected.to validate_presence_of :quantity }
      it { is_expected.to validate_presence_of :unit_of_measurement_id }

    end
  end
end
