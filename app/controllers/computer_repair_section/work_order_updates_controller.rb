module ComputerRepairSection 
  class WorkOrderUpdatesController < ApplicationController
    def create 
      @work_order_update = Update.create(update_params)
      @work_order_update.user = current_user
      @work_order_update.save 

      redirect_to computer_repair_section_work_order_url(@work_order_update.updateable), notice: "Update saved successfully."
    end

    private 
    def update_params
      params.require(:update).permit(:type, :title, :content, :date, :updateable_id, :updateable_type)
    end 
  end 
end 