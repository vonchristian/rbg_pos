module StoreFrontModule
  class PurchasePrice < ApplicationRecord
    belongs_to :product
    belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"
    belongs_to :store_front

    validates :price, :date, presence: true
    validates :price, numericality: true

    def self.latest
      order(date: :desc).first
    end
    
    def self.latest_price
      latest.price || 0
    end
  end
end
