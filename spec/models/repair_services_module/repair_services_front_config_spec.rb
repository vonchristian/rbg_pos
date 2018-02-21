require 'rails_helper'

module RepairServicesModule
  describe RepairServicesFrontConfig do
    describe 'associations' do
      it { is_expected.to belong_to :repair_services_front }
      it { is_expected.to belong_to :accounts_receivable_account }
    end
    describe "#default_accounts_receivable_account" do
      it "returns default if non created" do
        RepairServicesModule::RepairServicesFrontConfig.destroy_all

        expect(RepairServicesModule::RepairServicesFrontConfig.default_accounts_receivable_account).to eql (AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current (Repair Services"))
      end
    end
  end
end
