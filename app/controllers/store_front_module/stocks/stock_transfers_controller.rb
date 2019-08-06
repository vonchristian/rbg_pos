module StoreFrontModule
  module Stocks
    class StockTransfersController < ApplicationController
      def index
        @stock = current_store_front.stocks.find(params[:stock_id])
        @pagy, @stock_transfers = pagy(@stock.stock_transfers)
      end
    end
  end
end
