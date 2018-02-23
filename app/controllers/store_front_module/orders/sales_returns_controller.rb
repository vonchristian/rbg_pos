module StoreFrontModule
  module Orders
    class SalesReturnsController < ApplicationController
      def index
        @orders = StoreFrontModule::Orders::SalesReturnOrder.order(date: :desc).all.paginate(page: params[:page], per_page: 35)
      end
    end
  end
end
