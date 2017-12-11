class StoreController < ApplicationController
	def index
    if params[:line_item_search].present?
		  @stocks = Stock.text_search(params[:line_item_search]).all
    else
      @stocks = Stock.text_search(params[:search]).all
    end
		@line_item = LineItem.new
		@cart = current_cart
		@order = Order.new
	end
end
