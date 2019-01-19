module Reports
  module StoreFronts
    class InventoriesController < ApplicationController
      def index
        @store_front = current_business.store_fronts.find(params[:store_front_id])
        @products = current_business.products
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.current
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : (Date.current)
        respond_to do |format|
          format.html
          format.xlsx
        end
      end
    end
  end
end
