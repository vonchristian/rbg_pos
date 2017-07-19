class ProductsController < ApplicationController
	def index 
		if params[:search].present?
			@products = Product.text_search(params[:search])
		else
		  @products = Product.all 
		end
	end 
	def new 
		@product = Product.new 
		@category = Category.new
	end
	def create 
		@product = Product.create(product_params)
		if @product.valid?
			@product.save 
			redirect_to @product, notice: "Product saved successfully."
		else 
			render :new 
		end 
	end 
	def show 
		@product = Product.find(params[:id])
	end

	private 
	def product_params
		params.require(:product).permit(:category_id, :avatar, :name, :description, :retail_price, :wholesale_price, :unit)
	end
end 