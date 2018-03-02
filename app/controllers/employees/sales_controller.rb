module Employees
  class SalesController < ApplicationController
    def index
      @employee = current_user
      @orders = @employee.sales_orders.order(date: :desc).all.paginate(page: params[:page], per_page: 35)
    end
  end
end
