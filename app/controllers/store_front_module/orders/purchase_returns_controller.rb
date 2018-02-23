module StoreFrontModule
  module Orders
    class PurchaseReturnsController < ApplicationController
      def index
        @purchase_returns = StoreFrontModule::Orders::PurchaseReturnOrder.order(date: :desc).all.paginate(page: params[:page], per_page: 35)
      end
    end
  end
end
