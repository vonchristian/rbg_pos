module StoreFrontModule
  module StoreFronts
    class InventoriesController < ApplicationController
      def index
        @store_front = current_business.store_fronts.find(params[:store_front_id])
        @stocks = @store_front.stocks.processed.includes(:purchase, :sales, :stock_transfers, :internal_uses, :spoilages, :purchase_returns, :for_warranties, :sales_returns)
        respond_to do |format|
          format.html
          format.xlsx
        end
      end
    end
  end
end
