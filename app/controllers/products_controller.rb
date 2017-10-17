require 'will_paginate/array'
class ProductsController < ApplicationController
	def index
    if params[:search].present?
      @products = Product.text_search(params[:search]).paginate(page: params[:page], per_page: 20)
    else
      @products = Product.joins([:stocks, :sold_items]).all.order(:name).paginate(page: params[:page], per_page: 20)
    end
    @registry = Registry.new
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = ProductsPdf.new(@products = Product.joins([:stocks, :sold_items]).all, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Products PDF Report.pdf"
      end
    end
  end

  def out_of_stock 
    @out_of_stock_products = (Product.out_of_stock).paginate(page: params[:page], per_page: 35)
  end
  def low_on_stock 
    @low_on_stock_products = (Product.low_on_stock).paginate(page: params[:page], per_page: 35)
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
		@stocks = @product.stocks.all.paginate(page: params[:page], per_page: 30)
		@orders = @product.orders.all.paginate(page: params[:page], per_page: 30)

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
  def destroy 
    @product = Product.find(params[:id])
    @product.destroy 
    redirect_to products_url notice: "Product removed successfully"
  end


	private 
	def product_params
		params.require(:product).permit(:category_id, :avatar, :name, :description, :retail_price, :wholesale_price, :unit, :low_stock_count)
	end
end 