module StoreFrontModule
  module Orders
    class InternalUseOrder < Order
      has_many :internal_use_order_line_items, class_name: "StoreFrontModule::LineItems::InternalUseOrderLineItem", foreign_key: 'order_id'
      delegate :name, to: :employee, prefix: true
      has_many :stocks, through: :internal_use_order_line_items, class_name: 'StoreFronts::Stock'
    end
  end
end
