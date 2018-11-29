 module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItem < LineItem

      belongs_to :purchase_order, class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'order_id', optional: true
      has_many :referenced_purchase_order_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      has_many :purchase_return_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseReturnOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      has_many :internal_use_order_line_items, class_name: "StoreFrontModule::LineItems::InternalUseOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      has_many :stock_transfer_line_items, class_name: "StoreFrontModule::LineItems::StockTransferOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      has_many :sales_return_order_line_items, class_name: "StoreFrontModule::LineItems::SalesReturnOrderLineItem", foreign_key: 'purchase_order_line_item_id'
      delegate :supplier, to: :purchase_order, allow_nil: true
      delegate :business_name, to: :supplier, prefix: true, allow_nil: true
      def self.processed
        where.not(order_id: nil)
      end
      def processed?
        order_id.present?
      end

      def self.available
        select { |a| !a.out_of_stock? }
      end
      def sold?
        referenced_purchase_order_line_items &&  out_of_stock?
      end

      def date_sold
        referenced_purchase_order_line_items.last.try(:sales_order_line_item).try(:order).try(:date)

      end

      def out_of_stock?
        available_quantity <= 0
      end

      def sold_quantity
        referenced_purchase_order_line_items.total
      end

      def customer
        StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem.where(purchase_order_line_item_id: self.id).first.try(:sales_order_line_item).try(:order).try(:customer).try(:name)
      end

      def purchase_returns_quantity
        purchase_return_order_line_items.total
      end

      def available_quantity
        sales_returns_quantity +
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

      def sales_returns_quantity
        sales_return_order_line_items.total
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
