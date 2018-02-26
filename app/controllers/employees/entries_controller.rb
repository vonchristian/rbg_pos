module Employees
  class EntriesController < ApplicationController
    def index
      @employee = current_user
      @entries = @employee.entries.order(entry_date: :desc).all.paginate(page: params[:page], per_page: 35)
    end
  end
end
