class StoreController < ApplicationController
	def index
    if params[:search].present?
		  @products = Product.text_search(params[:search]).all
      @line_items = StoreFrontModule::LineItems::PurchaseOrderLineItem.processed.text_search(params[:search])
    end
		@sales_order_line_item = StoreFrontModule::LineItems::SalesOrderLineItemProcessing.new
		@cart = current_cart
		@sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
	end
end
