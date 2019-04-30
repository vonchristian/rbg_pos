module ComputerRepairSection
  class DashboardController < ApplicationController
    def index
      @from_date = params[:from_date] || DateTime.now.beginning_of_month
      @to_date = params[:to_date] || DateTime.now.end_of_month
      if params[:technician].present?
        @technician = User.find(params[:technician])
        @work_orders = @technician.work_orders.paginate(page: params[:page], per_page: 20)
      elsif params[:search].present?
        @work_orders = WorkOrder.text_search(params[:search]).paginate(page: params[:page], per_page: 20)
      elsif params[:section_id].present?
        @work_orders = Section.find(params[:section_id]).work_orders.paginate(page: params[:page], per_page: 20)
      else
        @work_orders = WorkOrder.all.paginate(page: params[:page], per_page: 20)
      end
    end
  end
end
