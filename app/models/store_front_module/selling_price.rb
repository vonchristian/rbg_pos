module StoreFrontModule
  class SellingPrice < ApplicationRecord
    belongs_to :store_front
    belongs_to :product
    belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"

    validates :price, numericality: true, presence: true
    before_save :set_default_date

    def self.price_for_unit_of_measurement(unit_of_measurement:)
      where(unit_of_measurement: unit_of_measurement).current_price
    end

    def self.current
      order(date: :desc).first
    end
    def self.current_price
      current.try(:price)
    end

    private
    def set_default_date
      self.date ||= Time.zone.now
    end
  end
end
