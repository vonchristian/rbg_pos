module ComputerRepairSection 
  class DashboardController < ApplicationController
    def index 
      if params[:technician].present?
        @technician = User.find(params[:technician])
        @work_orders = @technician.work_orders
      else
        @work_orders = WorkOrder.all
      end
    end 
  end 
end 