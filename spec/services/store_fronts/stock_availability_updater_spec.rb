require 'rails_helper'

module StoreFronts
  describe StockAvailabilityUpdater, type: :model do
    it '#update_availability!' do
      product     = create(:product, name: 'Test Product')
      uom         = create(:unit_of_measurement, product: product, base_measurement: true, conversion_quantity: 1)
      store_front = create(:store_front)
      cart        = create(:cart)
      stock                    = create(:stock, product: product, store_front: store_front, barcode: '11111111', unit_of_measurement: uom)
      supplier                 = create(:supplier)
      entry                    = create(:entry_with_credit_and_debit)
      voucher                  = create(:voucher, entry: entry, payee: supplier, reference_number: 'V001')
      purchase_order           = create(:purchase_order, supplier: supplier, voucher: voucher)
      purchase_order_line_item = create(:purchase_order_line_item, quantity: 10, stock: stock, purchase_order: purchase_order)

      expect(stock.available).to eql false
      described_class.new(stock: stock, cart: cart).update_availability!
      expect(stock.available).to eql true
    end
  end
end
