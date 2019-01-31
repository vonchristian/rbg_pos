class CustomersController < ApplicationController
	def index
		if params[:search].present?
			@customers = current_business.customers.text_search(params[:search]).paginate(page: params[:page], per_page: 20)
		else
			@customers = current_business.customers.paginate(page: params[:page], per_page: 35)
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
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to customers_url, alert: "Customer destroyed successfully"
  end

	private
	def customer_params
		params.require(:customer).permit(:first_name, :last_name, :contact_number, :address, :business_id)
	end
end
