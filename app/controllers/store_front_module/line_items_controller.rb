module StoreFrontModule
  class LineItemsController < ApplicationController
    def show
      @line_item = LineItem.find(params[:id])
    end
  end
end
