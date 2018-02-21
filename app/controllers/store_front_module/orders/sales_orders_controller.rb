module StoreFrontModule
  module Orders
    class SalesOrdersController < ApplicationController
      def index
        @sales_orders = StoreFrontModule::Orders::SalesOrder.order(date: :desc).
        paginate(page: params[:page], per_page: 35)
      end
      def show
        @order = StoreFrontModule::Orders::SalesOrder.find(params[:id])
      end
    end
  end
end
