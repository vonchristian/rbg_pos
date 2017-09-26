class ProductsController < ApplicationController
	def index
    if params[:search].present?
      @products = Product.text_search(params[:search]).page(params[:page]).per(20)
    else
      @products = Product.includes([:stocks, :sold_items]).all.order(:name).page(params[:page]).per(20)
      @low_on_stock_products = Kaminari.paginate_array(Product.low_on_stock).page(params[:page]).per(20)
    end
    @registry = Registry.new
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = ProductsPdf.new(@products, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Products PDF Report.pdf"
      end
    end
  end

  def out_of_stock 
    @out_of_stock_products = Kaminari.paginate_array(Product.out_of_stock).page(params[:page]).per(20)
  end
  def low_on_stock 
    @low_on_stock_products = Kaminari.paginate_array(Product.low_on_stock).page(params[:page]).per(20)
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
		params.require(:product).permit(:category_id, :avatar, :name, :description, :retail_price, :wholesale_price, :unit, :low_stock_count)
	end
end 