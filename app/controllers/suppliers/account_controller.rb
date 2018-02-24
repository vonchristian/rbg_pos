module Suppliers
  class AccountController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
    end
  end
end
