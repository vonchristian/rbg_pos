class SuppliersController < ApplicationController
	def index 
		if params[:search].present?
			@suppliers = Supplier.text_search(params[:search]).page(params[:page]).per(35)
		else
		  @suppliers = Supplier.all.page(params[:page]).per(35)
		end 
		authorize @suppliers
	end 
	def show 
		@supplier = Supplier.find(params[:id])
	end
end 