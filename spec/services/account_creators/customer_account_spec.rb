require 'rails_helper'

module AccountCreators
  describe Customer do
    it 'create_account' do
      account_number = "471b3d8b-fa56-40e6-8b84-cfc5259741ed"
      customer   = build(:customer, receivable_account_id: nil, account_number: account_number)

      expect(customer.receivable_account_id).to eql nil
      described_class.new(customer: customer).create_account!
      customer.save!

      receivable_account = AccountingModule::Asset.find_by(
        name: "Accounts Receivable - #{customer.full_name} - 471b3d8b-fa56-40e6-8b84-cfc5259741ed")

      expect(customer.receivable_account).to eql receivable_account
    end
  end
end
