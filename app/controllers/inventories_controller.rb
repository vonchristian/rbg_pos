class InventoriesController < ApplicationController
  def index
    if params[:search].present?
      @pagy, @stocks = pagy(StoreFronts::Stock.text_search(params[:search]))
    else
      @pagy, @stocks  = pagy(StoreFronts::Stock.where(store_front: current_store_front))
    end
  end
end
