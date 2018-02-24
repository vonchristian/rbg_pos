module StoreFrontModule
  module Orders
    class SalesOrdersController < ApplicationController
      def index
        @orders = StoreFrontModule::Orders::SalesOrder.order(date: :desc).
        paginate(page: params[:page], per_page: 30)
        @sales_for_today = StoreFrontModule::Orders::SalesOrder.ordered_on(from_date: Date.today, to_date: Date.today)
      end
      def show
        @order = StoreFrontModule::Orders::SalesOrder.find(params[:id])
      end
    end
  end
end
