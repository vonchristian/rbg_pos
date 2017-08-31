class CustomersController < ApplicationController 
	def index 
		if params[:search].present?
			@customers = Customer.text_search(params[:search]).page(params[:page]).per(35)
		else 
			@customers = Customer.all.page(params[:page]).per(35)
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
  def edit 
    @customer = Customer.find(params[:id])
  end
  def update 
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    if @customer.valid?
      @customer.save 
      redirect_to @customer, notice: 'Customer information updated successfully.'
    else 
      render :edit 
    end 
  end 

	private 
	def customer_params
		params.require(:customer).permit(:first_name, :last_name, :contact_number, :address)
	end 
end 