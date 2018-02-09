module StoreFrontModule
  class UnitOfMeasurement < ApplicationRecord
    belongs_to :product
    has_many :selling_prices, class_name: "StoreFrontModule::SellingPrice"
    def current_selling_price
      selling_prices.current_price
    end
    def self.base_measurement
      where(base_measurement: true).order(created_at: :asc).last
    end
  end
end
