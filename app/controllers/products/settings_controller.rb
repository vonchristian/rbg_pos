module Products 
  class SettingsController < ApplicationController 
    def index 
      @product = current_business.products.find(params[:product_id])
    end 
  end 
end 