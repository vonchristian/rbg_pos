module ComputerRepairSection 
  module WorkOrders
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
          @work_order.service_charge_entry(@charge)
          redirect_to new_computer_repair_section_work_order_service_charge_url(@work_order), notice: "Charge saved successfully"
        else 
          render :new 
        end 
      end 

      private
      def service_charge_params
        params.require(:work_order_service_charge).permit(:service_charge_id, :user_id)
      end 
    end 
  end
end 
