module Employees
  class ReportsController < ApplicationController
    def index
      @employee = current_user
    end
  end
end
