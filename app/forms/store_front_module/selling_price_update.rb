module StoreFrontModule
  class SellingPriceUpdate
    include ActiveModel::Model
    attr_accessor :selling_price, :product_id, :unit_of_measurement_id, :date

    validates :selling_price, :date,  presence: true
    validates :selling_price, numericality: true
    def update_price!
      ActiveRecord::Base.transaction do
        create_selling_price
      end
    end
    def find_product
      Product.find_by_id(product_id)
    end
    private
    def create_selling_price
      find_unit_of_measurement.selling_prices.create(date: date, price: selling_price, product_id: product_id)
    end

    def find_unit_of_measurement
      StoreFrontModule::UnitOfMeasurement.find_by_id(unit_of_measurement_id)
    end
  end
end
