class OrdersController < ApplicationController
	def index 
		@orders = Order.all 
		authorize @orders
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
			redirect_to @order, notice: "Order saved successfully."
		else 
			render :new 
		end 
	end 

	def show 
		@order = Order.find(params[:id])
		respond_to do |format| 
			format.html
			format.pdf do 
				pdf = OrderPdf.new(@order, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Order.pdf"
			end
		end
	end

	private 
	def order_params 
		params.require(:order).permit(:customer_id, :date, payment_attributes: [:mode_of_payment, :discount_amount, :cash_tendered, :change, :total_cost, :total_cost_less_discount])
	end
end