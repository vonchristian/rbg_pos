module Products
  class OrdersController < ApplicationController
    def index
      @product = Product.find(params[:product_id])
      @orders = @product.sales_orders.for_store_front(current_store_front).paginate(page: params[:page], per_page: 50)
    end
  end
end
