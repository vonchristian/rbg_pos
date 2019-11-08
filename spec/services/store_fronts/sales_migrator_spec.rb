require 'rails_helper'

module StoreFronts
  describe SalesMigrator do
    it 'migrate_sales!' do
      product                  = create(:product)
      uom                      = create(:unit_of_measurement, product: product)
      stock                    = create(:stock, product: product)
      entry                    = create(:entry_with_credit_and_debit)
      voucher                  = create(:voucher, entry: entry)
      order                    = create(:purchase_order, voucher: voucher)
      purchase_order_line_item = create(:purchase_order_line_item, product: product, stock: stock, purchase_order: order)
      sales_entry              = create(:entry_with_credit_and_debit)
      sales_voucher            = create(:voucher, entry: sales_entry)
      sales_order              = create(:sales_order, voucher: sales_voucher)
      sales_order_line_item    = create(:sales_order_line_item, order: sales_order, stock_id: nil)
      ref                      = StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem.create!(purchase_order_line_item: purchase_order_line_item, sales_order_line_item: sales_order_line_item, unit_of_measurement: uom)
      StoreFronts::SalesMigrator.new(sales_order_line_items: StoreFrontModule::LineItems::SalesOrderLineItem.all).migrate_sales!
      puts sales_order_line_item.inspect
      puts ref.inspect
      puts sales_order_line_item.purchase_order_line_items.inspect
      # expect(stock.sales).to include(sales_order_line_item)
    end
  end
end
