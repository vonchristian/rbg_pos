module StoreFrontModule
  module LineItems
    class SalesOrderLineItemProcessingsController < ApplicationController
      def create
        @sales_order_line_item = StoreFrontModule::LineItems::SalesOrderLineItemProcessing.new(line_item_params)
        if @sales_order_line_item.valid?
          @sales_order_line_item.process!
          update_stock_availability
          redirect_to store_index_url, notice: "added to cart"
        else
          redirect_to store_index_url, notice: "Error"
        end
      end
      def destroy
        @line_item = StoreFrontModule::LineItems::SalesOrderLineItem.find(params[:id])
        @stock = @line_item.stock
        @line_item.destroy
        update_available_quantity_on_destroy
        redirect_to store_index_url, notice: "Removed successfully"
      end

      private

      def update_stock_availability
        StockAvailabilityUpdaterJob.perform_later(stock_id: params[:store_front_module_line_items_sales_order_line_item_processing][:stock_id], cart_id: params[:store_front_module_line_items_sales_order_line_item_processing][:cart_id])
      end

      def update_available_quantity_on_destroy
        StockAvailabilityUpdaterJob.perform_later(stock_id: @stock.id, cart_id: current_cart.id)
      end

      def line_item_params
        params.require(:store_front_module_line_items_sales_order_line_item_processing).permit(:quantity,
          :unit_of_measurement_id, :store_front_id, :unit_cost, :product_id, :cart_id, :bar_code, :stock_id)
      end
    end
  end
end
