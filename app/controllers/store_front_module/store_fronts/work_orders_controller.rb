module StoreFrontModule
  module StoreFronts
    class WorkOrdersController < ApplicationController
      def index
        @store_front = current_business.store_fronts.find(params[:store_front_id])
        @work_orders = @store_front.work_orders
        respond_to do |format|
          format.html
          format.xlsx
        end 
      end
    end
  end
end
