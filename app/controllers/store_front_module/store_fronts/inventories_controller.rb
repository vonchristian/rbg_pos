module StoreFrontModule
  module StoreFronts
    class InventoriesController < ApplicationController
      def index
        @store_front = current_business.store_fronts.find(params[:store_front_id])
        @stocks = @store_front.stocks
        respond_to do |format|
          format.html
          format.xlsx
        end
      end
    end
  end
end
