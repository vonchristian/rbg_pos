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
	def destroy 
		@line_item = LineItem.find(params[:id])
		@line_item.destroy 
		redirect_to orders_url, notice: 'Line item returned successfully.'
	end
  def update 
    @line_item = LineItem.find(params[:id])
    @line_item.update(line_item_params)
    if @line_item.save 
      redirect_to new_order_path, notice: 'Markup added successfully'
    else 
      redirect_to new_order_path, alert: "Error"
    end 
  end

	private 
	def line_item_params
		params.require(:line_item).permit(:stock_id, :unit_cost, :total_cost, :quantity, :markup_amount)
	end
end