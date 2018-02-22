module RepairServicesModule
  class ServicePaymentsController < ApplicationController
    def index
      @service_payments = RepairServicesModule::RepairServicesFrontConfig.default_accounts_receivable_account.credit_entries.order(entry_date: :desc).paginate(page: params[:page], per_page: 35)
    end
    def show
      @payment = AccountingModule::Entry.find(params[:id])
    end
  end
end
