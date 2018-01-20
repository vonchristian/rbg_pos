module Products
  class OrdersController < ApplicationController
    def index
      @product = Product.find(params[:product_id])
      @orders = @product.orders.all.paginate(page: params[:page], per_page: 50)
    end
  end
end