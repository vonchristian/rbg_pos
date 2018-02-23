module RepairServicesModule
  class RepairServiceOrderLineItemProcessingsController < ApplicationController
    def new
      @work_order = WorkOrder.find(params[:work_order_id])
      if params[:search].present?
        @products = Product.text_search(params[:search]).all
        @purchase_order_line_items = StoreFrontModule::LineItems::PurchaseOrderLineItem.text_search(params[:search]).all
      end
      @repair_service_order_line_item = RepairServicesModule::RepairServiceOrderLineItemProcessing.new
      @cart = current_cart
      @repair_service_order = RepairServicesModule::RepairServiceOrderProcessing.new
    end

    def create
      @work_order = WorkOrder.find(params[:work_order_id])
      @repair_service_order_line_item = RepairServicesModule::RepairServiceOrderLineItemProcessing.new(line_item_params)
      if @repair_service_order_line_item.valid?
        @repair_service_order_line_item.process!
        redirect_to new_repair_services_module_work_order_repair_service_order_line_item_processing_url(@work_order), notice: "added to cart"
      else
        render :new
      end
    end

    private
    def line_item_params
      params.require(:repair_services_module_repair_service_order_line_item_processing).permit(:quantity,
        :unit_of_measurement_id, :product_id, :cart_id, :work_order_id)
    end
  end
end