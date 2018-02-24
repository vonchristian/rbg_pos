module Accounting
  class FinancesController < ApplicationController
    def index
      @accounts = AccountingModule::Account.cash_on_hand_accounts.all
    end
  end
end
