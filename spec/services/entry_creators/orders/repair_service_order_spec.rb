require 'rails_helper'

module EntryCreators
  module Orders 
    describe RepairServiceOrder do 
      it "#create_entry!" do 
        sales_clerk = create(:sales_clerk)
        sales_order = create(:sales_order, store_front: sales_clerk.store_front)
        work_order  = create(:work_order, store_front: sales_clerk.store_front)

        described_class.new(sales_order: sales_order, work_order: work_order, employee: sales_clerk).create_entry!

        expect(work_order.receivable_account.debit_entries.count).to eql 1
      end 
    end 
  end 
end 