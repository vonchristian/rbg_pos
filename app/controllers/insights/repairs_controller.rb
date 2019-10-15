module Insights
  class RepairsController < ApplicationController
    def index
      @receivable_account = AccountingModule::AccountCategories::Asset.find_by(title: 'Service Income Receivable')
    end
  end
end
