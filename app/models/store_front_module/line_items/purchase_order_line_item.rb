 module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItem < LineItem

      belongs_to :purchase_order, class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'order_id', optional: true
      has_many :referenced_purchase_order_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      has_many :purchase_return_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseReturnOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      has_many :internal_use_order_line_items, class_name: "StoreFrontModule::LineItems::InternalUseOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      has_many :stock_transfer_line_items, class_name: "StoreFrontModule::LineItems::StockTransferOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      has_many :returned_sales_line_items, class_name: "StoreFrontModule::LineItems::ReferencedSalesOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      delegate :supplier, to: :purchase_order, allow_nil: true
      delegate :business_name, to: :supplier, prefix: true, allow_nil: true
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
      def sold?
        referenced_purchase_order_line_items &&  out_of_stock?
      end

      def out_of_stock?
        available_quantity <=0
      end

      def sold_quantity
        referenced_purchase_order_line_items.total -
        returned_sales_line_items_quantity
      end

      def customer
        StoreFrontModule::LineItems::SalesOrderLineItem.where(bar_code: self.bar_code).last.try(:order).try(:customer).try(:name)
      end

      def purchase_returns_quantity
        purchase_return_order_line_items.total
      end

      def available_quantity
        converted_quantity -
        sold_quantity -
        purchase_returns_quantity -
        internal_uses_quantity -
        stock_transfers_quantity
      end

      def internal_uses_quantity
        internal_use_order_line_items.total
      end

      def stock_transfers_quantity
        stock_transfer_line_items.total
      end

      def returned_sales_line_items_quantity
        returned_sales_line_items.total
      end

      def purchase_cost
        return unit_cost if unit_of_measurement.blank?
        if unit_of_measurement.present? && unit_of_measurement.base_measurement?
          unit_cost
        else
          unit_cost / unit_of_measurement.conversion_multiplier
        end
      end
    end
  end
end
