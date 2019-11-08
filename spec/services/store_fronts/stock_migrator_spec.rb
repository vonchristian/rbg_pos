require 'rails_helper'

module StoreFronts
  describe StockMigrator do
    it 'create_stock' do
      product                  = create(:product)
      entry                    = create(:entry_with_credit_and_debit)
      voucher                  = create(:voucher, entry: entry)
      order                    = create(:purchase_order, voucher: voucher)
      purchase_order_line_item = create(:purchase_order_line_item, product: product, purchase_order: order, stock_id: nil)

      described_class.new(purchase_order_line_item: purchase_order_line_item).create_stock

      expect(purchase_order_line_item.stock).to_not eql nil
    end
  end
end
