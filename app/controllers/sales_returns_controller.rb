class SalesReturnsController < ApplicationController
	def index
		@sales_returns = SalesReturn.all.order(date: :asc).paginate(page: params[:page], per_page: 30)
	end
end
