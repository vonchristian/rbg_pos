module Customers
  class SettingsController < ApplicationController
    def index
      @customer = Customer.find(params[:customer_id])
    end
  end
end
