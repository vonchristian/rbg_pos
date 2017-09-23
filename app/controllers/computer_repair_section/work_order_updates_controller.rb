module ComputerRepairSection 
  class WorkOrderUpdatesController < ApplicationController
    def create 
      @work_order_update = Update.create(update_params)
      @work_order_update.user = current_user
      if @work_order_update.valid?
        @work_order_update.save  
        @work_order_update.updateable.add_technician(current_user)
        redirect_to computer_repair_section_work_order_url(@work_order_update.updateable), notice: "Update saved successfully."
      else 
        redirect_to computer_repair_section_work_order_url(@work_order_update.updateable), alert: "Update not accepted. Please complete update details."
      end
    end

    private 
    def update_params
      params.require(:update).permit(:type, :title, :content, :date, :updateable_id, :updateable_type)
    end 
  end 
end 