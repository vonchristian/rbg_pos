class CashAccountsController < ApplicationController
  def show
    @cash_account = AccountingModule::Asset.find(params[:id])
  end
end 
