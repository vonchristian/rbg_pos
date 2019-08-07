class StoreController < ApplicationController
	def index
    if params[:search].present?
      @stocks          = current_store_front.stocks.processed.text_search(params[:search])
      @pagy, @products = pagy(Product.text_search(params[:search]))
    end

		@sales_order_line_item = StoreFrontModule::LineItems::SalesOrderLineItemProcessing.new
		@cart = current_cart
		@sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
	end
end
