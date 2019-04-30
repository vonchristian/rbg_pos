require 'rails_helper'

module AccountCreators
  describe WorkOrder do
    it 'create_account' do
      customer   = create(:customer)
      work_order = build(:work_order, receivable_account_id: nil, customer: customer)

      expect(work_order.receivable_account_id).to eql nil
      described_class.new(work_order: work_order).create_account!
      work_order.save!

      receivable_account = AccountingModule::Asset.find_by(
        name: "Accounts Receivable Work Orders - #{work_order.customer_name} #{work_order.service_number}")

      expect(work_order.receivable_account).to eql receivable_account
    end
  end
end
