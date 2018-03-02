require 'will_paginate/array'
module Customers
  class AccountController < ApplicationController
    def index
      @customer = Customer.find(params[:customer_id])
      @payments = @customer.payment_entries.paginate(page: params[:page], per_page: 35)
    end
  end
end
