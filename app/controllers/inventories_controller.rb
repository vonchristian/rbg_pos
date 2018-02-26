class InventoriesController < ApplicationController
  def index
    @inventories  = StoreFrontModule::LineItems::PurchaseOrderLineItem.order(created_at: :desc).all.paginate(page: params[:page], per_page: 35)
  end
end
