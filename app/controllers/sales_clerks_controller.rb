class SalesClerksController < ApplicationController
  def show
    @employee = current_business.employees.find(params[:id])
  end
end
