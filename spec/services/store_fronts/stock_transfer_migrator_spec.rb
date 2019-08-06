require 'rails_helper'

module StoreFronts
  describe StockTransferMigrator do
    it 'migrate!' do
      product                     = create(:product)
      uom                         = create(:unit_of_measurement, product: product)
      stock                       = create(:stock, product: product)
      entry                       = create(:entry_with_credit_and_debit)
      voucher                     = create(:voucher, accounting_entry: entry)
      order                       = create(:purchase_order, voucher: voucher)
      purchase_order_line_item    = create(:purchase_order_line_item, product: product, stock: stock, purchase_order: order)
      transfer_entry              = create(:entry_with_credit_and_debit)
      transfer_voucher            = create(:voucher, accounting_entry: transfer_entry)
      transfer_order              = create(:stock_transfer_order, voucher: transfer_voucher)
      transfer_order_line_item    = create(:stock_transfer_order_line_item, order: transfer_order, purchase_order_line_item: purchase_order_line_item, stock: stock)
      described_class.new(purchase_order_line_item: purchase_order_line_item).migrate!

      expect(stock.stock_transfers).to include(transfer_order_line_item)

    end
  end
end
