module Customers
  class OrdersController < ApplicationController
    def index
      @customer = Customer.find(params[:customer_id])
      @orders = @customer.orders.order(date: :desc).all.paginate(page: params[:page], per_page: 50)
    end
  end
end
