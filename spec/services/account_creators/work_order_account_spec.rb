require 'rails_helper'

module AccountCreators
  describe WorkOrder do
    it 'create_account' do
      customer   = create(:customer)
      work_order = create(:work_order, customer: customer, receivable_account_id: nil)

      described_class.new(work_order: work_order).create_accounts!
      work_order.save!

      receivable_account = AccountingModule::Asset.find_by(
        name: "Accounts Receivable Work Orders - #{work_order.customer_name} ##{work_order.service_number}")
      sales_revenue_account = AccountingModule::Revenue.find_by(
        name: "Sales (Work Orders) - #{work_order.customer_name} ##{work_order.service_number}")
      sales_discount_account = AccountingModule::Revenue.find_by(
        name: "Sales Discounts (Work Orders) - #{work_order.customer_name} ##{work_order.service_number}")
      expect(work_order.receivable_account).to eql receivable_account
      expect(work_order.sales_revenue_account).to eql sales_revenue_account
      expect(work_order.sales_discount_account).to eql sales_discount_account

    end
  end
end
