module StoreFrontModule
  module Orders
    class PurchaseOrdersController < ApplicationController
      def index
        @orders = StoreFrontModule::Orders::PurchaseOrder.not_stock_transfers.order(date: :desc).all.paginate(page: params[:page], per_page: 30)
      end
      def show
        @order = StoreFrontModule::Orders::PurchaseOrder.find(params[:id])
        @pagy, @line_items = pagy(@order.purchase_order_line_items.order(created_at: :asc))
      end 
    end
  end
end
