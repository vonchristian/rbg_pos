class StockAvailabilityUpdaterJob < ApplicationJob
  queue_as :default

  def perform(stock_id:, cart_id:)
    stock = StoreFronts::Stock.find(stock_id)
    cart  = Cart.find(cart_id)

    if stock.balance_for_cart(cart) <= 0
      stock.update!(available: false)
    elsif stock.balance_for_cart(cart) > 0
      stock.update!(available: true)
    end
  end
end
