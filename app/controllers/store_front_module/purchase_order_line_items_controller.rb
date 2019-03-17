module StoreFrontModule
  class PurchaseOrderLineItemsController < ApplicationController
    def show
      @stock = StoreFrontModule::LineItems::PurchaseOrderLineItem.find(params[:id])
    end
  end
end
