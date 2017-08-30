module Products
  class StocksController < ApplicationController 
    def index 
      if params[:search].present?
        @stocks= Stock.text_search(params[:search]).page(params[:page]).per(35)
      else
        @stocks = Stock.all.page(params[:page]).per(35)
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
    def edit 
      @stock = Stock.find(params[:id])
    end
    def update 
      @stock = Stock.find(params[:id])
      @stock.update(stock_params)
      if @stock.valid?
        @stock.save 
        redirect_to product_url(@stock.product), notice: 'Stock updated successfully.'
      end
    end
    def show 
      @stock = Stock.find(params[:id])
    end

    def destroy 
      @stock = Stock.find(params[:id])
      authorize @stock
      @stock.destroy 
      redirect_to stocks_url, alert: "Stock deleted successfully."
    end

    private 
    def stock_params
      params.require(:stock).permit(:stock_type, :supplier_id, :unit_cost, :total_cost, :quantity, :retail_price, :wholesale_price, :barcode, :name, :origin_branch_id)
    end 
  end
end