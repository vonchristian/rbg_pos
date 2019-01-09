module Reports
  class RepairsController < ApplicationController
    def index
      @from_date = params[:from_date] || DateTime.now.beginning_of_month
      @to_date = params[:to_date] || DateTime.now.end_of_month
      @employee = User.find(params[:user_id])
      @work_orders = @employee.released_repairs.from(from_date: @from_date, to_date: @to_date)
      respond_to do |format|
        format.xlsx
      end
    end
  end
end
