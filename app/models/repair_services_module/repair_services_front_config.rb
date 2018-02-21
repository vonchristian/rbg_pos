module RepairServicesModule
  class RepairServicesFrontConfig < ApplicationRecord
    belongs_to :accounts_receivable_account, class_name: "AccountingModule::Account"
    belongs_to :repair_services_front, class_name: "RepairServicesModule::RepairServicesFront"

    def self.default_accounts_receivable_account
      AccountingModule::Asset.find_by(name: "Accounts Receivables Trade - Current (Repair Services)")
    end
  end
end
