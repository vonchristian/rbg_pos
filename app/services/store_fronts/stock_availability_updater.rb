module StoreFronts
  class StockAvailabilityUpdater
    attr_reader :stock, :cart
    def initialize(stock:, cart:)
      @stock = stock
      @cart = cart
    end

    def update_availability!
      if stock.balance_for_cart(cart) <= 0
        stock.update!(available: false)
      elsif stock.balance_for_cart(cart) > 0
        stock.update!(available: true)
      end
    end
  end
end
