module StoreFrontModule
  module LineItems
    class WorkOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode, :referenced_line_item_id, :store_front_id
      validates :quantity, numericality: { greater_than: 0.1 }
      validate :quantity_is_less_than_or_equal_to_available_quantity?

      def process!
        ActiveRecord::Base.transaction do
          process_purchase
        end
      end

      private
      def process_purchase
        if product_id.present?
          decrease_product_available_quantity
        end
      end

      def quantity_for(purchase, remaining_quantity)
        if purchase.available_quantity >= BigDecimal(remaining_quantity)
          BigDecimal(remaining_quantity)
        else
          purchase.available_quantity.to_f
        end
      end

      def decrease_product_available_quantity
        remaining_quantity = quantity.to_f
        find_product.purchases.order(date: :asc).available.each do |purchase|
            sales = find_cart.sales_order_line_items.create!(quantity: quantity_for(purchase, remaining_quantity),
                                                   unit_cost: selling_cost,
                                                   total_cost: set_total_cost(purchase, remaining_quantity),
                                                   unit_of_measurement: find_product.base_measurement,
                                                   product_id: product_id,
                                                   referenced_line_item: purchase)
            remaining_quantity -= sales.quantity
            break if remaining_quantity.zero?
        end
      end

      def find_cart
        StoreFrontModule::Cart.find_by_id(cart_id)
      end

      def selling_cost
        find_unit_of_measurement.price_for_store_front(store_front: find_store_front)
      end

      def set_total_cost(purchase, remaining_quantity)
        selling_cost * quantity_for(purchase, remaining_quantity)
      end

      def find_unit_of_measurement
        StoreFrontModule::UnitOfMeasurement.find_by_id(unit_of_measurement_id)
      end

      def find_product
        Product.find_by_id(product_id)
      end

      def find_store_front
        StoreFront.find(store_front_id)
      end

      def find_purchase_order_line_item
        StoreFrontModule::LineItems::PurchaseOrderLineItem.find_by_id(referenced_line_item_id)
      end

      def available_quantity
        if product_id.present?
          find_product.available_quantity
        elsif referenced_line_item_id.present?
          find_purchase_order_line_item.available_quantity
        end
      end

      def quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if quantity.to_f > available_quantity
      end
    end
  end
end
