module StoreFronts
  class StockAvailabilityUpdater
    attr_reader :stock
    def initialize(stock:)
      @stock = stock
    end
    
    def update_availability!
      if stock.balance <= 0
        stock.update_attributes!(available: false)
      elsif stock.balance > 0
        stock.update_attributes!(available: true)
      end
    end
  end
end
