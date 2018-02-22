module RepairServicesModule
  class RepairServiceOrderProcessingsController < ApplicationController
    def create
      @work_order = WorkOrder.find(params[:work_order_id])
      @repair_service_order = RepairServicesModule::RepairServiceOrderProcessing.new(order_params)
      if @repair_service_order.valid?
        @repair_service_order.process!
        redirect_to "/", notice: "Order processed successfully"
      else
        redirect_to new_repair_services_module_work_order_work_order_line_item_processing_url(@work_order), alert: "Error"
      end
    end

    private
    def order_params
      params.require(:repair_services_module_repair_service_order_processing).permit(:cart_id, :employee_id, :date, :customer_id, :work_order_id)
    end
  end
end
