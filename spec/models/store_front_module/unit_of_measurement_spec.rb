require 'rails_helper'

module StoreFrontModule
  describe UnitOfMeasurement do
    describe 'associations' do
      it { is_expected.to belong_to :product }
      it { is_expected.to have_many :selling_prices }
    end

    describe 'validations' do
      it {is_expected.to validate_presence_of      :unit_code }
      it {is_expected.to validate_presence_of      :quantity }
      it { is_expected.to validate_numericality_of :quantity }
    end

    it '.base_measurement' do
      base_unit_of_measurement   = create(:unit_of_measurement, base_measurement: true, created_at: Date.yesterday)
      base_unit_of_measurement_2 = create(:unit_of_measurement, base_measurement: true, created_at: Date.today)
      unit_of_measurement_2      = create(:unit_of_measurement, base_measurement: false)

      expect(described_class.base_measurement).to eql(base_unit_of_measurement_2)
      expect(described_class.base_measurement).to_not eql(base_unit_of_measurement)
      expect(described_class.base_measurement).to_not eql(unit_of_measurement_2)
    end

    it '.latest' do
      old_unit_of_measurement    = create(:unit_of_measurement, base_measurement: true, created_at: Date.yesterday)
      latest_unit_of_measurement = create(:unit_of_measurement, base_measurement: true, created_at: Date.today)

      expect(described_class.latest).to eql(latest_unit_of_measurement)
      expect(described_class.latest).to_not eql(old_unit_of_measurement)
    end

    it "#conversion_multiplier" do
      base_measurement   = create(:unit_of_measurement, base_measurement: true, quantity: 10)
      not_base_measurement = create(:unit_of_measurement, base_measurement: false, conversion_quantity: 5)

      expect(base_measurement.conversion_multiplier).to eql 10
      expect(not_base_measurement.conversion_multiplier).to eql 5

    end

    it "#default_conversion_quantity" do
      unit_of_measurement   = create(:unit_of_measurement, conversion_quantity: nil)
      unit_of_measurement_2 = create(:unit_of_measurement, conversion_quantity: 10)

      expect(unit_of_measurement.default_conversion_quantity).to eql 1
      expect(unit_of_measurement_2.default_conversion_quantity).to eql 10

    end
  end
end
