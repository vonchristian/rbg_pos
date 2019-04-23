module Admin
  module Employees
    class SettingsController < ApplicationController
      def index
        @employee = current_store_front.employees.find(params[:employee_id])
      end
    end
  end
end
