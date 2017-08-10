module LineItems
	class SalesReturnsController < ApplicationController
		def new 
			@line_item = LineItem.find(params[:line_item_id])
			if @line_item.returned?
				redirect_to order_path(@line_item.order), alert: "Item is already returned"
			else 
			  @sales_return = @line_item.build_sales_return
			end
		end
		def create
			@line_item = LineItem.find(params[:line_item_id])
			@sales_return = @line_item.create_sales_return(sales_return_params)
			@sales_return.barcode = @line_item.stock.barcode 
			@sales_return.name = @line_item.stock.name 
			if @sales_return.valid?
				@sales_return.save
				redirect_to order_path(@line_item.order), notice: "Item returned successfully."
			else 
				render :new 
			end 
		end

		private 
		def sales_return_params
			params.require(:sales_return).permit(:date, :sales_return_type, :remarks, :quantity)
		end
	end 
end 
