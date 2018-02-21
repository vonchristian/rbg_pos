module Suppliers
  class PurchaseOrdersController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
    end
  end
end
