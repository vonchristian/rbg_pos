require 'rails_helper'

module StoreFrontModule
  describe PurchasePrice do
    describe 'associations' do
      it { is_expected.to belong_to :product }
      it { is_expected.to belong_to :unit_of_measurement }
      it { is_expected.to belong_to :store_front }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :price }
      it { is_expected.to validate_presence_of :date }
      it { is_expected.to validate_numericality_of :price }
    end

    it ".latest" do
      old = create(:purchase_price, date: Date.yesterday)
      latest = create(:purchase_price, date: Date.current)

      expect(described_class.latest).to eql latest
      expect(described_class.latest).to_not eql old
    end

    it ".latest_price" do
      old    = create(:purchase_price, date: Date.yesterday, price: 100)
      latest = create(:purchase_price, date: Date.current,   price: 200)

      expect(described_class.latest_price).to eql 200
      expect(described_class.latest_price).to_not eql 100
    end
  end
end
