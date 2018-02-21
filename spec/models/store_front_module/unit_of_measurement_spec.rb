require 'rails_helper'
module StoreFrontModule
  RSpec.describe UnitOfMeasurement, type: :model do
    describe 'associations' do
      it { is_expected.to belong_to :product }
      it { is_expected.to have_many :selling_prices }
    end

    describe 'validations' do
      it {is_expected.to validate_presence_of :unit_code }
      it {is_expected.to validate_presence_of :quantity }
      it { is_expected.to validate_numericality_of :quantity }
    end
    it "#price" do
      product = create(:product)
      unit_of_measurement = create(:unit_of_measurement, product: product)
      selling_price = create(:selling_price, unit_of_measurement: unit_of_measurement, price: 500, product: product)

      expect(unit_of_measurement.price).to eql(500)
    end
  end
end
