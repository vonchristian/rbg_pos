require 'rails_helper'

module StoreFronts
  describe InternalUseMigrator do
    it 'migrate!' do
      product                      = create(:product)
      uom                          = create(:unit_of_measurement, product: product)
      stock                        = create(:stock, product: product)
      entry                        = create(:entry_with_credit_and_debit)
      voucher                      = create(:voucher, entry: entry)
      order                        = create(:purchase_order, voucher: voucher)
      purchase_order_line_item     = create(:purchase_order_line_item, product: product, stock: stock, purchase_order: order)
      internal_entry               = create(:entry_with_credit_and_debit)
      internal_voucher             = create(:voucher, entry: internal_entry)
      internal_order               = create(:internal_use_order, voucher: internal_voucher)
      internal_use_order_line_item = create(:internal_use_order_line_item, order: internal_order)
      internal_use_order_line_item.referenced_purchase_order_line_items.create!(purchase_order_line_item: purchase_order_line_item, unit_of_measurement: uom)
      described_class.new(internal_use_order_line_items: StoreFrontModule::LineItems::InternalUseOrderLineItem.all).migrate!

      expect(stock.internal_uses).to include(internal_use_order_line_item)
    end
  end
end
