require 'rails_helper'

module AccountCreators
  describe WorkOrder do
    it 'create_accounts!' do
      customer   = create(:customer)
      work_order = create(:work_order, receivable_account_id: nil, customer: customer)

      expect(work_order.receivable_account_id).to eql nil
      described_class.new(work_order: work_order).create_accounts!
      work_order.save!

      receivable_account = AccountingModule::Asset.find_by!(
        name: "Accounts Receivable Work Orders - #{customer.name} #{work_order.service_number}")
      service_revenue_account = AccountingModule::Revenue.find_by!(
        name: "Service Income - #{customer.name} #{work_order.service_number}")
      sales_discount_account = AccountingModule::Revenue.find_by!(
        name: "Service Income Discounts - #{customer.name} #{work_order.service_number}")
      expect(work_order.receivable_account).to eql receivable_account
      expect(work_order.service_revenue_account).to eql service_revenue_account

    end
  end
end
