module Reports
  class ProductsController < ApplicationController
    def index
      @products = Product.all
      respond_to do |format|
        format.xlsx
      end
    end
  end
end
