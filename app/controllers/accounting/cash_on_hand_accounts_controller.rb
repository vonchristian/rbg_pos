module Accounting
  class CashOnHandAccountsController < ApplicationController
    def new
      @account = AccountingModule::Asset.new
    end
    def create
      @account = AccountingModule::Asset.create(account_params)
      if @account.valid?
        @account.save
        redirect_to accounting_index_url, notice: "Cash on Hand Account created successfully"
      else
        render :new
      end
    end

    private
    def account_params
      params.require(:accounting_module_asset).permit(:account_code, :name)
    end
  end
end
