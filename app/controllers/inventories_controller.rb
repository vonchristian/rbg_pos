class InventoriesController < ApplicationController
  def index
    if params[:search].present?
      @inventories = StoreFrontModule::LineItems::PurchaseOrderLineItem.processed.for_store_front(current_store_front).text_search(params[:search]).paginate(page: params[:page], per_page: 35)
    else
      @inventories  = StoreFrontModule::LineItems::PurchaseOrderLineItem.processed.for_store_front(current_store_front).order(created_at: :desc).all.paginate(page: params[:page], per_page: 35)
    end
  end
end
