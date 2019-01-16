module StoreFrontModule
  module Orders
    class PurchaseOrdersController < ApplicationController
      def index
        @orders = StoreFrontModule::Orders::PurchaseOrder.not_stock_transfers.order(date: :desc).all.paginate(page: params[:page], per_page: 30)
      end
      def show
        @order = StoreFrontModule::Orders::PurchaseOrder.find(params[:id])
        @line_items = @order.purchase_order_line_items.order(created_at: :asc).paginate(page: params[:page], per_page: 35)
      end
    end
  end
end
