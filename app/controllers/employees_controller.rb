class EmployeesController < ApplicationController
  def index 
    @employees = User.all 
    @products = Product.most_bought.limit(20)
    @customers = Customer.all.page(params[:page]).per(10)
  end 
  def show 
    @employee = User.find(params[:id])
    authorize @employee
  end 
end 