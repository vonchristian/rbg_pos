module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItemProcessingsController < ApplicationController
      def create
        @line_item = StoreFrontModule::LineItems::PurchaseOrderLineItemProcessing.new(line_item_params)
        if @line_item.valid?
          @line_item.process!
          redirect_to new_store_front_module_purchase_order_url, notice: "added successfully"
        else
          render :new
        end
      end

      private
      def line_item_params
        params.require(:store_front_module_line_items_purchase_order_line_item_processing).permit(:quantity, :unit_of_measurement_id, :product_id, :barcode, :cart_id)
      end
    end
  end
end
