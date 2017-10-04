class SuppliersController < ApplicationController
	def index 
		if params[:search].present?
			@suppliers = Supplier.text_search(params[:search]).paginate(page: params[:page], per_page: 20)
		else
		  @suppliers = Supplier.all.paginate(page: params[:page], per_page: 20)
		end 
		authorize @suppliers
	end 
	def show 
		@supplier = Supplier.find(params[:id])
    @stocks = @supplier.delivered_stocks.paginate(page: params[:page], per_page: 20)
	end
end 