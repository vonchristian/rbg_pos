class CustomerRegistrationsController < ApplicationController
	def new 
		@customer = Customer.new 
	end 
	def create 
		@customer = Customer.create(customer_params)
	end 
	private 
	def customer_params
		params.require(:customer).permit(:first_name, :last_name, :address, :contact_number)
	end 
end 