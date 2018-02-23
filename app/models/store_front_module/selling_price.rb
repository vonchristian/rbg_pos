module StoreFrontModule
  class SellingPrice < ApplicationRecord
    belongs_to :product
    belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"

    validates :price, numericality: true, presence: true
    def self.current
      order(date: :desc).first
    end
    def self.current_price
      current.try(:price)
    end
  end
end
