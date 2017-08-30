class ProductsController < ApplicationController
	def index
    if params[:name].present?
      @products = Product.search_by_name(params[:name]).page(params[:page]).per(30)
    else
      @products = Product.all.order(:name).page(params[:page]).per(30)
    end
    @registry = Registry.new
  end
  
	def new 
		@product = Product.new 
		authorize @product
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
		@stocks = @product.stocks.all.page(params[:page]).per(35)
		@orders = @product.orders.all.page(params[:page]).per(35)

	end
	def edit 
		@product = Product.find(params[:id])
		authorize @product
	end 
	def update 
		@product = Product.find(params[:id])
		authorize @product
		@product.update(product_params)
		if @product.valid?
			@product.save 
      @product.update_stocks_name
			redirect_to @product, notice: "Product updated successfully"
		else
			render :new 
		end 
	end 


	private 
	def product_params
		params.require(:product).permit(:category_id, :avatar, :name, :description, :retail_price, :wholesale_price, :unit)
	end
end 