module StoreFrontModule
  class UnitOfMeasurement < ApplicationRecord
    belongs_to :product
    has_many :selling_prices, class_name: "StoreFrontModule::SellingPrice"

    validates :unit_code, :quantity, presence: true
    validates :quantity, numericality: true

    def self.base_measurement #TODO rename to latest_base_measurement
      where(base_measurement: true).latest
    end

    def self.latest
      order(created_at: :asc).last
    end
    def price #remove
      selling_prices.current_price
    end

    def price_for_store_front(store_front:)
      selling_prices.price_for_store_front(store_front: store_front)
    end

    def conversion_multiplier
      if base_measurement?
        quantity
      else
        default_conversion_quantity
      end
    end

    def default_conversion_quantity
      conversion_quantity || 1
    end
  end
end
