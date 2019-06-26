module StoreFrontModule
  class SellingPriceUpdate
    include ActiveModel::Model
    attr_accessor :selling_price, :product_id, :unit_of_measurement_id, :date, :store_front_ids

    validates :selling_price, :date,  presence: true
    validates :selling_price, numericality: true
    def update_price!
      ActiveRecord::Base.transaction do
        create_selling_price
      end
    end
    def find_product
      Product.find(product_id)
    end
    private

    def create_selling_price
      store_fronts.each do |store_front|
        store_front.selling_prices.create(
          date: date,
          price: selling_price,
          product_id: product_id,
          unit_of_measurement: find_unit_of_measurement
        )
      end
    end

    def find_unit_of_measurement
      StoreFrontModule::UnitOfMeasurement.find(unit_of_measurement_id)
    end
    def store_fronts
      StoreFront.where(id: store_front_ids.uniq.compact.flatten)
    end
  end
end
