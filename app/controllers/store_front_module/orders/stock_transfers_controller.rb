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
          if current_user.proprietor?
            format.xlsx
          end
        end
      end
      def edit
        @stock_transfer = StoreFrontModule::Orders::StockTransferOrder.find(params[:id])
      end
      def update
        @stock_transfer = StoreFrontModule::Orders::StockTransferOrder.find(params[:id])
        @stock_transfer.update(stock_transfer_params)
        if @stock_transfer.valid?
          @stock_transfer.save
          redirect_to store_front_module_stock_transfer_url(@stock_transfer), notice: "Updated successfully"
        else
          render :edit
        end
      end
      def destroy
        @order = StoreFrontModule::Orders::StockTransferOrder.find(params[:id])
        @order.destroy
        redirect_to store_front_module_stock_transfers_url, alert: "Deleted successfully"
      end
      private
      def stock_transfer_params
        params.require(:store_front_module_orders_stock_transfer_order).
        permit(:destination_store_front_id)
      end
    end
  end
end
