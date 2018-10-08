module StoreFrontModule
  module LineItems
    class SalesReturnOrderLineItemProcessingsController < ApplicationController
      def new
        if params[:search].present?
          @products = Product.text_search(params[:search]).all
          @line_items = StoreFrontModule::LineItems::PurchaseOrderLineItem.processed.text_search(params[:search])
        end
        @cart = current_cart
        @sales_return_order_line_item = StoreFrontModule::LineItems::SalesReturnOrderLineItemProcessing.new
        @sales_return_order = StoreFrontModule::Orders::SalesReturnOrderProcessing.new
        @sales_return_order_line_items = @cart.sales_return_order_line_items.order(created_at: :desc)
      end

      def create
        @sales_return_order_line_item = StoreFrontModule::LineItems::SalesReturnOrderLineItemProcessing.new(line_item_params)
        if @sales_return_order_line_item.valid?
          @sales_return_order_line_item.process!
          redirect_to new_store_front_module_sales_return_order_line_item_processing_url, notice: "added to cart"
        else
          render :new, notice: "Error"
        end
      end
      def destroy
        @line_item = StoreFrontModule::LineItems::SalesReturnOrderLineItem.find(params[:id])
        @line_item.destroy
        redirect_to new_store_front_module_sales_return_order_line_item_processing_url, notice: "Removed successfully"
      end

      private
      def line_item_params
        params.require(:store_front_module_line_items_sales_return_order_line_item_processing).permit(:quantity,
          :unit_of_measurement_id, :product_id, :cart_id, :bar_code, :purchase_order_line_item_id)
      end
    end
  end
end
