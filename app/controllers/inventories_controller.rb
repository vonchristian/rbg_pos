class InventoriesController < ApplicationController
  def index
    if params[:search].present?
      @pagy, @stocks = pagy(current_store_front.stocks.text_search(params[:search]))
    else
      @pagy, @stocks  = pagy(current_store_front.stocks)
    end
  end
end
