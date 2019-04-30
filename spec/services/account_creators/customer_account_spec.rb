require 'rails_helper'

module AccountCreators
  describe Customer do
    it 'create_accounts!' do
      account_number = "471b3d8b-fa56-40e6-8b84-cfc5259741ed"
      customer   = build(:customer, receivable_account_id: nil, account_number: account_number)

      expect(customer.receivable_account_id).to eql nil
      described_class.new(customer: customer).create_accounts!
      customer.save!

      receivable_account = AccountingModule::Asset.find_by(
        name: "Accounts Receivable - #{customer.full_name} - #471b3d8b-fa56-40e6-8b84-cfc5259741ed")
      sales_revenue_account = AccountingModule::Revenue.find_by(
        name: "Sales - #{customer.full_name} - ##{customer.account_number}")
      sales_discount_account = AccountingModule::Revenue.find_by(
        name: "Sales Discounts - #{customer.full_name} - ##{customer.account_number}")
      service_revenue_account = AccountingModule::Revenue.find_by(
        name: "Service Income - #{customer.full_name} - ##{customer.account_number}")

      expect(customer.receivable_account).to eql receivable_account
      expect(customer.sales_revenue_account).to eql sales_revenue_account
      expect(customer.sales_discount_account).to eql sales_discount_account
      expect(customer.service_revenue_account).to eql service_revenue_account

    end
  end
end
