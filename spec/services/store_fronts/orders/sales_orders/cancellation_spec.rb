require 'rails_helper'

module StoreFronts
  module Orders
    module SalesOrders
      describe Cancellation do
        it "#cancel" do
          entry           = create(:entry_with_credit_and_debit)
          voucher         = create(:voucher, entry: entry)
          sales_order     = create(:sales_order, voucher: voucher)
          sales_line_item = create(:sales_order_line_item, sales_order: sales_order)

          described_class.new(sales_order: sales_order).cancel!
          expect(AccountingModule::Entry.find_by(id: entry.id)).to eql nil
          expect(Voucher.find_by(id: voucher.id)).to eql nil
          expect(LineItem.find_by(id: sales_line_item.id)).to eql nil
          expect(Order.find_by(id: sales_order.id)).to eql nil
          expect(AccountingModule::Account.find_by(id: sales_order.receivable_account_id)).to eql nil
          expect(AccountingModule::Account.find_by(id: sales_order.sales_revenue_account_id)).to eql nil

        end
      end
    end
  end
end
