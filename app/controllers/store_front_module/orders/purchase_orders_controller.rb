module StoreFrontModule
  module Orders
    class PurchaseOrdersController < ApplicationController
      def index
        @orders = StoreFrontModule::Orders::PurchaseOrder.order(date: :desc).all.paginate(page: params[:page], per_page: 30)
      end
      def show
        @order = StoreFrontModule::Orders::PurchaseOrder.find(params[:id])
      end
    end
  end
end
