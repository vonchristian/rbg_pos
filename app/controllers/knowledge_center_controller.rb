class KnowledgeCenterController < ApplicationController 
  def index 
    if params[:search].present?
      @searches = PgSearch.multisearch(params[:search]).page(params[:page]).per(20)
    else
      @work_orders = WorkOrder.all.page(params[:page]).per(20)
    end
  end 
end 