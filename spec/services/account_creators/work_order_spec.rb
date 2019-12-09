require 'rails_helper'

module AccountCreators
  describe WorkOrder, type: :model do
    it '#create_accounts' do
      customer   = create(:customer)
      work_order = FactoryBot.build(:work_order, customer: customer, receivable_account_id: nil, sales_revenue_account_id: nil, service_revenue_account_id: nil)

      described_class.new(work_order: work_order).create_accounts!

      work_order.save!

      expect(work_order.receivable_account).to_not eq nil
      expect(work_order.sales_revenue_account).to_not eq nil
      expect(work_order.service_revenue_account).to_not eq nil
      expect(work_order.sales_discount_account).to_not eq nil

    end
  end
end
