module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItem < LineItem
      belongs_to :purchase_order, class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'order_id', optional: true
      has_many :referenced_purchase_order_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      has_many :purchase_return_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseReturnOrderLineItem", foreign_key: 'purchase_order_line_item_id'

      def self.processed
        select{|a| a.processed? }
      end
      def processed?
        purchase_order
        # && purchase_order.processed?
      end

      def self.available
        select { |a| !a.out_of_stock? }
      end

      def out_of_stock?
        available_quantity.zero?
      end

      def sold_quantity
        referenced_purchase_order_line_items.total
      end

      def purchase_returns_quantity
        purchase_return_order_line_items.total
      end

      def available_quantity
        converted_quantity -
        sold_quantity -
        purchase_returns_quantity
      end

      def purchase_cost
        if unit_of_measurement.base_measurement?
          unit_cost
        else
          unit_cost / unit_of_measurement.conversion_multiplier
        end
      end
    end
  end
end
