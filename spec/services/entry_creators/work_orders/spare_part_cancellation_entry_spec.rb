require 'rails_helper'

module EntryCreators
  module WorkOrders 
    describe SparePartCancellationEntry do 
      it "#create_entry!" do 
        technician            = create(:technician)
        proprietor            = create(:proprietor, store_front: technician.store_front)
        work_order            = create(:work_order, store_front: technician.store_front)
        stock                 = create(:stock)
        purchase_order        = create(:purchase_order)
        create(:purchase_order_line_item, order: purchase_order, stock: stock, quantity: 10)
        sales_order           = create(:sales_order, commercial_document: work_order)
        sales_order_line_item = create(:sales_order_line_item, order: sales_order, stock: stock)
        
        entry = build(:entry, commercial_document: sales_order)
        entry.debit_amounts.build(amount: sales_order.total_cost, account: work_order.receivable_account)
        entry.credit_amounts.build(amount: sales_order.total_cost, account: work_order.sales_revenue_account)
        entry.save!
        
        expect(work_order.receivable_account.balance).to eql 100
        described_class.new(
          employee: technician,
          work_order: work_order,
          line_item: sales_order_line_item
        ).create_entry!

        expect(work_order.receivable_account.balance).to eql 0

      end 
    end 
  end 
end 