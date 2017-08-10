class StocksController < ApplicationController 
	def index 
		if params[:search].present?
			@stocks= Stock.text_search(params[:search])
		else
		  @stocks = Stock.all 
		end
	end
	def new 
		@product = Product.find(params[:product_id])
		@stock = @product.stocks.build 
	end 
	def create 
		@product = Product.find(params[:product_id])
		@stock = @product.stocks.create(stock_params)
		@stock.branch = current_user.branch
		if @stock.save
			redirect_to @product, notice: "Stock saved successfully."
		else 
			render :new 
		end 
	end 
	def show 
		@stock = Stock.find(params[:id])
	end

	private 
	def stock_params
		params.require(:stock).permit(:supplier_id, :unit_cost, :total_cost, :quantity, :retail_price, :wholesale_price, :barcode, :name)
	end 
end