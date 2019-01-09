module RepairServices
  class PerEmployeeDashboardsController < ApplicationController
    def index
      @employee = User.find(params[:user_id])
      @work_orders = @employee.work_orders.paginate(page: params[:page], per_page: 25)
      authorize [:repair_services, :per_employee_dashboards]
    end
  end
end
