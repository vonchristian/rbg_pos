class LineItemsController < ApplicationController
	def create 
		@cart = current_cart
		@line_item = @cart.line_items.create(line_item_params)
		if @line_item.save 
		  redirect_to store_index_url, notice: "added successfully"
		else 
			redirect_to store_index_url, alert: 'Quantity exceeded available stocks'
		end
	end 

	private 
	def line_item_params
		params.require(:line_item).permit(:stock_id, :unit_cost, :total_cost, :quantity)
	end
end