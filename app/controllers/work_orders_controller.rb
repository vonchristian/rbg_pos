class WorkOrdersController < ApplicationController
  def index 
  end
  def new 
    @work_order = WorkOrderForm.new 
  end
  def create 
    @work_order = WorkOrderForm.new(work_order_params)
    if @work_order.valid?
      @work_order.save 
      redirect_to work_orders_url, notice: "Work Order saved successfully."
    else 
      render :new 
    end 
  end 

  private 
  def work_order_params
    params.require(:work_order_form).permit(:description, :model_number, :serial_number, :physical_condition, :reported_problem)
  end
end