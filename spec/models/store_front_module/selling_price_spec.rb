require 'rails_helper'

module StoreFrontModule
  describe SellingPrice do
    describe 'associations' do
      it { is_expected.to belong_to :product }
      it { is_expected.to belong_to :unit_of_measurement }
      it { is_expected.to belong_to :store_front }
    end

    it ".price_for_unit_of_measurement(unit_of_measurement:)" do
      business            = create(:business)
      store_front         = create(:store_front, business: business)
      store_front_2        = create(:store_front, business: business)
      product             = create(:product, business: business)
      unit_of_measurement = create(:unit_of_measurement, product: product)
      selling_price       = create(:selling_price, store_front: store_front, product: product, unit_of_measurement: unit_of_measurement, price: 100)
      selling_price_2     = create(:selling_price, store_front: store_front_2, product: product, price: 200, unit_of_measurement: unit_of_measurement)

      expect(store_front.selling_prices.price_for_unit_of_measurement(unit_of_measurement: unit_of_measurement)).to eql 100
      expect(store_front_2.selling_prices.price_for_unit_of_measurement(unit_of_measurement: unit_of_measurement)).to eql 200
    end

    it ".for_unit_of_measurement(unit_of_measurement:)" do
      business            = create(:business)
      store_front         = create(:store_front, business: business)
      store_front_2        = create(:store_front, business: business)
      product             = create(:product, business: business)
      unit_of_measurement = create(:unit_of_measurement, product: product)
      selling_price       = create(:selling_price, store_front: store_front, product: product, unit_of_measurement: unit_of_measurement, price: 100)
      selling_price_2     = create(:selling_price, store_front: store_front_2, product: product, price: 200, unit_of_measurement: unit_of_measurement)

      expect(store_front.selling_prices.for_unit_of_measurement(unit_of_measurement: unit_of_measurement)).to eql selling_price
      expect(store_front_2.selling_prices.for_unit_of_measurement(unit_of_measurement: unit_of_measurement)).to eql selling_price_2
    end

    it ".price_for_store_front(store_front:)" do
      business            = create(:business)
      store_front         = create(:store_front, business: business)
      store_front_2        = create(:store_front, business: business)
      product             = create(:product, business: business)
      unit_of_measurement = create(:unit_of_measurement, product: product)
      selling_price       = create(:selling_price, store_front: store_front, product: product, unit_of_measurement: unit_of_measurement, price: 100)
      selling_price_2     = create(:selling_price, store_front: store_front_2, product: product, price: 200, unit_of_measurement: unit_of_measurement)

      expect(unit_of_measurement.selling_prices.price_for_store_front(store_front: store_front)).to eql 100
      expect(unit_of_measurement.selling_prices.price_for_store_front(store_front: store_front_2)).to eql 200
    end
  end
end
