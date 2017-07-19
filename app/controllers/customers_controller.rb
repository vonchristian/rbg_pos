class CustomersController < ApplicationController 
	def index 
		if params[:search].present?
			@customers = Customer.text_search(params[:search])
		else 
			@customers = Customer.all 
		end 
	end 
	def new 
		@customer = Customer.new 
	end 
	def create 
		@customer = Customer.create(customer_params)
		if @customer.valid?
			@customer.save 
			redirect_to customers_url, notice: "Customer saved successfully"
		else 
			render :new 
		end 
	end 
	def show 
		@customer = Customer.find(params[:id])
	end

	private 
	def customer_params
		params.require(:customer).permit(:first_name, :last_name, :contact_number, :address)
	end 
end 