class StoreController < ApplicationController
	def index
    if params[:search].present?
      @line_items = current_store_front.purchase_order_line_items.processed.for_store_front(current_store_front).text_search(params[:search])
      @products   = Product.text_search(params[:search]).all
    end
		@sales_order_line_item = StoreFrontModule::LineItems::SalesOrderLineItemProcessing.new
		@cart = current_cart
		@sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
	end
end
