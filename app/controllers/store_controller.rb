class StoreController < ApplicationController
	def index
    if params[:search].present?
		  @products = Product.text_search(params[:search]).all
      @purchase_order_line_items = StoreFrontModule::LineItems::PurchaseOrderLineItem.text_search(params[:search]).all
    end
		@sales_order_line_item = StoreFrontModule::LineItems::SalesOrderLineItemProcessing.new
		@cart = current_cart
		@sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
	end
end
