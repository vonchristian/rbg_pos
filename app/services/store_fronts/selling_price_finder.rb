module StoreFronts
  class SellingPriceFinder
    attr_reader :selling_prices, :store_front, :stock
    def initialize(stock:, store_front:)
      @stock               = stock
      @store_front         = store_front
      @unit_of_measurement = @stock.unit_of_measurement
      @selling_prices      = @unit_of_measurement.selling_prices
    end

    def selling_price
      price = selling_prices.where(store_front: store_front).current
      if price
        price.price
      else
        stock.product.try(:base_measurement).try(:price)
      end
    end
  end
end
