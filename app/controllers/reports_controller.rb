class ReportsController < ApplicationController
	def index 
    @products = Product.all.paginate(page:params[:page], per_page: 100)
	end 
end 