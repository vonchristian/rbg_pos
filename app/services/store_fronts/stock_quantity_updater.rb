module StoreFronts
  class StockQuantityUpdater
    attr_reader :stock

    def initialize(stock:)
      @stock = stock
    end

    def update_available_quantity!
      if stock.purchase.present?
        stock.update(available_quantity: stock.balance)
      end 
    end
  end
end
