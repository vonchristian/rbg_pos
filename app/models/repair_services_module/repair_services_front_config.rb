module RepairServicesModule
  class RepairServicesFrontConfig < ApplicationRecord
    belongs_to :accounts_receivable_account, class_name: "AccountingModule::Account"
    belongs_to :repair_services_front, class_name: "RepairServicesModule::RepairServicesFront"

    def self.default_accounts_receivable_account
      AccountingModule::Asset.find_by(name: "Accounts Receivables Trade - Current (Repair Services)")
    end

    def self.default_services_revenue_account
      AccountingModule::Revenue.find_by(name: 'Service Fees')
    end
    def self.default_discount_account
      AccountingModule::Revenue.find_by(name: "Sales Discounts")
    end
  end
end
