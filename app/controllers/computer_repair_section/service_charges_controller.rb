module ComputerRepairSection 
  class ServiceChargesController < ApplicationController
    def new 
      @work_order = WorkOrder.find(params[:work_order_id])
      @charge = @work_order.work_order_service_charges.build 
    end 
    def create 
      @work_order = WorkOrder.find(params[:work_order_id])
      @charge = @work_order.work_order_service_charges.create(service_charge_params)
      if @charge.valid?
        @charge.save
        redirect_to computer_repair_section_work_order_url(@work_order), notice: "Charge saved successfully"
      else 
        render :new 
      end 
    end 

    private
    def service_charge_params
      params.require(:work_order_service_charge).permit(:service_charge_id)
    end 
  end 
end 
