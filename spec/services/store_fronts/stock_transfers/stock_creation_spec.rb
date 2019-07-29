require 'rails_helper'

module StoreFronts
  module StockTransfers
    describe StockCreation, type: :model do
      it '#create_stock!' do
        stock              = create(:stock)
        purchase_line_item = create(:purchase_order_line_item, stock: stock)
        store_front        = create(:store_front)

        described_class.new(line_item: purchase_line_item, destination_store_front: store_front).create_stock!

        expect(purchase_line_item.stock).to_not eql stock
        expect(purchase_line_item.stock).to_not eql nil
      end
    end
  end
end
