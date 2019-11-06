require 'rails_helper'

module AccountCreators
  describe SalesOrder do
    it 'create_accounts!' do
      customer   = create(:customer)
      sales_order = create(:sales_order, commercial_document: customer, sales_revenue_account_id: nil, sales_discount_account_id: nil, receivable_account_id: nil)

      expect(sales_order.receivable_account_id).to eql nil
      expect(sales_order.sales_revenue_account_id).to eql nil

      described_class.new(sales_order: sales_order).create_accounts!
      sales_order.save!

      receivable_account = AccountingModule::Asset.find_by(
        name: "Accounts Receivable Sales Orders - #{sales_order.customer_name} ##{sales_order.account_number}")
      sales_revenue_account = AccountingModule::Revenue.find_by(
        name: "Sales Orders - #{sales_order.customer_name} ##{sales_order.account_number}")
        sales_discount_account = AccountingModule::Revenue.find_by(
          name: "Sales Order Discounts - #{sales_order.customer_name} ##{sales_order.account_number}")

      expect(sales_order.receivable_account).to    eql receivable_account
      expect(sales_order.sales_revenue_account).to eql sales_revenue_account
      expect(sales_order.sales_discount_account).to eql sales_discount_account

    end
  end
end
