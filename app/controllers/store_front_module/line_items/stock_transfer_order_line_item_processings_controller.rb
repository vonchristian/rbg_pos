module StoreFrontModule
  module LineItems
    class StockTransferOrderLineItemProcessingsController < ApplicationController
      def new
        if params[:search].present?
          @products = Product.text_search(params[:search]).all
          @line_items = StoreFrontModule::LineItems::PurchaseOrderLineItem.processed.for_store_front(current_store_front).text_search(params[:search])
        end
        @cart = current_cart
        @stock_transfer_order_line_item = StoreFrontModule::LineItems::StockTransferOrderLineItemProcessing.new
        @stock_transfer_order = StoreFrontModule::Orders::StockTransferOrderProcessing.new
        @purchase_order_line_items = @cart.purchase_order_line_items.order(created_at: :desc)
      end

      def create
        @line_item = StoreFrontModule::LineItems::StockTransferOrderLineItemProcessing.new(line_item_params)
        if @line_item.valid?
          @line_item.process!
          redirect_to new_store_front_module_stock_transfer_order_line_item_processing_url, notice: "added successfully"
        else
          render :new, alert: "Error"
        end
      end
      def destroy
        @line_item = StoreFrontModule::LineItems::PurchaseOrderLineItem.find(params[:id])
        @line_item.destroy
        redirect_to new_store_front_module_stock_transfer_order_line_item_processing_url, notice: "Removed successfully"
      end

      private
      def line_item_params
        params.require(:store_front_module_line_items_stock_transfer_order_line_item_processing).
        permit(:quantity, :unit_of_measurement_id, :product_id, :bar_code, :cart_id, :purchase_order_line_item_id)
      end
    end
  end
end
