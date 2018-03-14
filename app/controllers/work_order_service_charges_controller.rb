class WorkOrderServiceChargesController < ApplicationController
  def destroy
    @service_charge = WorkOrderServiceCharge.find(params[:id])
    @service_charge.destroy
    redirect_to new_repair_services_module_work_order_service_charge_processing_path(@service_charge.work_order), notice: "Service charge deleted successfully"
  end
end
