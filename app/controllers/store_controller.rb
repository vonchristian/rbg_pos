class StoreController < ApplicationController 
	def index 
		@stocks = Stock.text_search(params[:search])
		@line_item = LineItem.new 
		@cart = current_cart
		@order = Order.new 
	end 
end 