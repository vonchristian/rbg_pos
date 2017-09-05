class EmployeesController < ApplicationController
  def index 
    @employees = User.all 
    @products = Product.most_bought.first(10)
    @customers = Customer.recent(10)
  end 
  def show 
    @employee = User.find(params[:id])
    authorize @employee
  end 
end 