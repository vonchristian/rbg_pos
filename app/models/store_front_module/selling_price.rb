module StoreFrontModule
  class SellingPrice < ApplicationRecord
    belongs_to :product
    belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"

    validates :price, numericality: true, presence: true
    def self.current_price
      order(date: :desc).first.try(:price)
    end
  end
end
