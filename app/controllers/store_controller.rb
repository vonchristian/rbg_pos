class StoreController < ApplicationController 
	def index 
    if params[:line_item_search].present?
		  @stocks = Stock.text_search(params[:line_item_search]).paginate(page: params[:page], per_page: 30)
    else 
      @stocks = Stock.text_search(params[:search]).paginate(page: params[:page], per_page: 30)
    end
		@line_item = LineItem.new 
		@cart = current_cart
		@order = Order.new 
	end 
end 