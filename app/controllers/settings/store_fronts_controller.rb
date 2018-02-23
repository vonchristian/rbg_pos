module Settings
  class StoreFrontsController < ApplicationController
    def new
      @store_front = StoreFront.new
    end
    def create
      @store_front = StoreFront.create(store_front_params)
      if @store_front.save
        @store_front.save
        redirect_to settings_url, notice: 'Store Front created successfully.'
      else
        render :new
      end
    end

    private
    def store_front_params
      params.require(:store_front).permit(:name, :address, :business_id, :merchandise_inventory_account_id)
    end
  end
end
