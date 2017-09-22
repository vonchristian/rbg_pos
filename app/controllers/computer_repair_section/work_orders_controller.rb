module ComputerRepairSection 
  class WorkOrdersController < ApplicationController
    def new 
      @work_order = WorkOrder.new 
      @work_order.build_product_unit
    end 
    def create 
      @work_order = WorkOrder.create(work_order_params)
      if @work_order.valid?
        @work_order.save 
        @work_order.technician = current_user
        redirect_to computer_repair_section_dashboard_index_url, notice: "Received successfully."
        @work_order.received!
      else 
        render :new 
      end 
    end 
    def show 
      @work_order = WorkOrder.find(params[:id])
      @work_order_update = @work_order.work_order_updates.build
    end
    def edit 
      @work_order = WorkOrder.find(params[:id])
    end 
    def update 
      @work_order = WorkOrder.find(params[:id])
      @work_order.update(work_order_params)
      if @work_order.save 
        redirect_to computer_repair_section_work_order_url(@work_order), notice: "Updated successfully"
      else 
        render :show 
      end 
    end 

    private 
    def work_order_params
      params.require(:work_order).permit(:status, :customer_id, product_unit_attributes: [:description, :model_number, :serial_number])
    end 
  end 
end 