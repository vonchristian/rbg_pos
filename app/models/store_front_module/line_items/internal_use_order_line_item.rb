module StoreFrontModule
  module LineItems
    class InternalUseOrderLineItem < LineItem
      has_many :referenced_purchase_order_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem", as: :referencer, dependent: :destroy
      has_many :purchase_order_line_items, through: :referenced_purchase_order_line_items
      belongs_to :internal_use_order, class_name: "StoreFrontModule::Orders::InternalUseOrder", foreign_key: 'order_id', optional: true
      delegate :date,  to: :internal_use_order, prefix: true
      delegate :reference_number, :employee_name, to: :internal_use_order

    end
  end
end
