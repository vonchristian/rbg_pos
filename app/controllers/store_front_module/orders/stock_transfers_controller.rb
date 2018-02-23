module StoreFrontModule
  module Orders
    class StockTransfersController < ApplicationController
      def index
        @stock_transfer_orders = StoreFrontModule::Orders::StockTransferOrder.order(date: :desc).paginate(page: params[:page], per_page: 35)
      end
      def show
        @order = StoreFrontModule::Orders::StockTransferOrder.find(params[:id])
        respond_to do |format|
          format.html
          format.xlsx
        end
      end
    end
  end
end
