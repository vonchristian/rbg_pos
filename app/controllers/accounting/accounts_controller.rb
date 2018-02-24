module Accounting
  class AccountsController < ApplicationController
    def index
      @accounts = AccountingModule::Account.active.all.order(:account_code).all.paginate(page: params[:page], per_page: 35)
    end
    def show
      @account = AccountingModule::Account.find(params[:id])
      @entries = @account.entries.order(entry_date: :desc).all.paginate(page: params[:page], per_page: 50)
    end
    def deactivate
      @account = AccountingModule::Account.find(params[:id])
      @account.deactivate!
      redirect_to accounting_accounts_url, notice: "Account deactivated successfully."
    end
  end
end
