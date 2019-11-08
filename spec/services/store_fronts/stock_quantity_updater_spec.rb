require 'rails_helper'

module StoreFronts
  describe StockQuantityUpdater do
    it '#update_available_quantity!' do
      stock = create(:stock)

      entry    = create(:entry_with_credit_and_debit)
      voucher  = create(:voucher, entry: entry)
      order    = create(:purchase_order, voucher: voucher)
      purchase = create(:purchase_order_line_item, quantity: 100, stock: stock)
      order.line_items << purchase

      expect(stock.available_quantity).to eql 0

      described_class.new(stock: stock).update_available_quantity!

      expect(stock.available_quantity).to eql 100

      sale_entry   = create(:entry_with_credit_and_debit)
      sale_voucher = create(:voucher, entry: sale_entry)
      sales_order  = create(:sales_order, voucher: sale_voucher)
      sale         = create(:sales_order_line_item, stock: stock, quantity: 10)
      sales_order.line_items << sale

      described_class.new(stock: stock).update_available_quantity!
      expect(stock.available_quantity).to eql 90



    end
  end
end
