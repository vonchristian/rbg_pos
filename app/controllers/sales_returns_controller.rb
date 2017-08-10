class SalesReturnsController < ApplicationController
	def index 
		@sales_returns = SalesReturn.all.page(params[:page]).per(35)
	end 
end 