module Suppliers
  class PurchaseOrdersController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
      @orders = @supplier.purchase_orders.order(date: :desc).paginate(page: params[:page], per_page: 20)
    end
  end
end
