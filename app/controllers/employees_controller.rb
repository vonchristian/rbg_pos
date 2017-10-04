class EmployeesController < ApplicationController
  def index 
    @employees = User.all 
    @products = Product.most_bought.first(10)
    @customers = Customer.recent(10)
  end 
  def show 
    @employee = User.find(params[:id])
    @orders = @employee.orders.paginate(page: params[:page], per_page: 35)
    authorize @employee
  end 
end 