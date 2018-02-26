module Customers
  class AccountController < ApplicationController
    def index
      @customer = Customer.find(params[:customer_id])
      @payments = @customer.payment_entries.order(entry_date: :desc).all.paginate(page: params[:page], per_page: 35)
    end
  end
end
