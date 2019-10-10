module ComputerRepairSection
  class DashboardController < ApplicationController
    def index
      @from_date = params[:from_date] || DateTime.now.beginning_of_month
      @to_date   = params[:to_date] || DateTime.now.end_of_month
      if params[:technician].present?
        @technician = User.find(params[:technician])
        @work_orders = @technician.work_orders.paginate(page: params[:page], per_page: 20)
      elsif params[:search].present?
        @pagy, @work_orders = pagy(WorkOrder.text_search(params[:search]))
      elsif params[:section_id].present?
        @work_orders = Section.find(params[:section_id]).work_orders.paginate(page: params[:page], per_page: 20)
      else
        @pagy, @work_orders = pagy(WorkOrder.all)
      end
      @pagy, @received_work_orders = pagy(WorkOrder.all.received)
      @pagy, @work_in_progress_work_orders = pagy(WorkOrder.all.work_in_progress)
      @pagy, @released_work_orders = pagy(WorkOrder.all.released)
      @pagy, @done_and_rto_work_orders = pagy(WorkOrder.all.done_and_rto)

    end
  end
end
