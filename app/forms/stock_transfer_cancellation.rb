class StockTransferCancellation
  attr_reader :line_item, :cart, :stock

  def initialize(line_item:, cart:)
    @line_item = line_item
    @cart      = cart
    @stock     = @line_item.stock
  end

  def cancel_transfer!
    cart.stock_transfer_order_line_items.where(stock: stock).destroy_all
  end
end
