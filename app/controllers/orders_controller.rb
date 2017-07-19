class OrdersController < ApplicationController
	def index 
		@orders = Order.all 
	end
	def new 
		@cart = current_cart
		@order = Order.new 
		@order.build_payment
	end 
	def create 
		@cart = current_cart
		@order = Order.new(order_params)
		if @order.valid?
			@order.add_line_items_from_cart(@cart)
			@order.save
			redirect_to store_index_url, notice: "Order saved successfully"
		else 
			render :new 
		end 
	end 

	def show 
		@order = Order.find(params[:id])
	end

	private 
	def order_params 
		params.require(:order).permit(:customer_id, :date, payment_attributes: [:mode_of_payment, :discount_amount, :cash_tendered, :change, :total_cost, :total_cost_less_discount])
	end
end