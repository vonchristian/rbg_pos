module StoreFrontModule
  module StoreFronts
    class InventoriesController < ApplicationController
      def index
        @store_front = current_business.store_fronts.find(params[:store_front_id])
        @stocks      = @store_front.stocks.processed.includes(:product,  :purchase =>[:purchase_order =>[:supplier]], :sales =>[:sales_order, :unit_of_measurement], :internal_uses =>[:unit_of_measurement], :stock_transfers =>[:purchase_order, :unit_of_measurement])
        respond_to do |format|
          format.html
          format.xlsx
        end
      end
    end
  end
end
