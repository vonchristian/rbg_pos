class ChargeInvoicesController < ApplicationController
  def index
    if params[:search].present?
      @charge_invoices = Invoices::ChargeInvoice.text_search(params[:search]).paginate(page: params[:page], per_page: 35)
    else
      @charge_invoices = Invoices::ChargeInvoice.all.paginate(page: params[:page], per_page: 35)
    end
  end
end
