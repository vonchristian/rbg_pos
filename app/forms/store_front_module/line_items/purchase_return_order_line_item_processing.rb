module StoreFrontModule
  module LineItems
    class PurchaseReturnOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id,
                    :quantity,
                    :cart_id,
                    :product_id,
                    :unit_cost,
                    :total_cost,
                    :cart_id,
                    :bar_code,
                    :purchase_order_line_item_id

      validates :quantity, numericality: { greater_than: 0.1 }
      validates :description, presence: true
      validate :quantity_is_less_than_or_equal_to_available_quantity?
      def process!
        ActiveRecord::Base.transaction do
          process_line_item
        end
      end

      private
      def process_line_item
        if product_id.present? && bar_code.blank?
          decrease_product_available_quantity
        elsif purchase_order_line_item_id.present? && bar_code.present?
            decrease_purchase_line_item_quantity
        end
      end
      def decrease_product_available_quantity

        requested_quantity = quantity.to_f

        find_product.purchases.order(created_at: :asc).available.each do |purchase|
          temp_purchase_return = find_cart.purchase_return_order_line_items.create!(
              quantity:                 quantity.to_f,
              unit_cost:                purchase_cost,
              total_cost:               total_cost_for(purchase, quantity),
              unit_of_measurement:      find_product.base_measurement,
              product_id:               product_id,
              purchase_order_line_item_id: purchase.id,
              bar_code:                 bar_code)
          requested_quantity -= temp_purchase_return.quantity
          break if requested_quantity.zero?
        end
      end
      def decrease_purchase_line_item_quantity
        sales = find_cart.purchase_return_order_line_items.create!(
          quantity: quantity,
          unit_cost: purchase_cost,
          total_cost: set_total_cost,
          product_id: product_id,
          unit_of_measurement: find_unit_of_measurement,
          bar_code: bar_code,
          purchase_order_line_item_id: find_purchase_order_line_item.id
          )

      end

      def quantity_for(purchase, requested_quantity)
        if purchase.available_quantity >= BigDecimal(requested_quantity)
          BigDecimal(requested_quantity)
        else
          purchase.available_quantity.to_f
        end
      end

      def set_total_cost
        (purchase_cost * quantity.to_f)
      end

      def total_cost_for(purchase, requested_quantity)
        purchase_cost * quantity_for(purchase, requested_quantity)
      end

      def find_cart
        Cart.find_by_id(cart_id)
      end

      def purchase_cost
        if purchase_order_line_item_id.present?
          find_purchase_order_line_item.unit_cost
        else
          find_product.last_purchase_cost
        end
      end

      def find_product
        Product.find_by_id(product_id)
      end

      def find_purchase_order_line_item
        StoreFrontModule::LineItems::PurchaseOrderLineItem.find_by_id(purchase_order_line_item_id)
      end
      def find_unit_of_measurement
        find_product.unit_of_measurements.find_by_id(unit_of_measurement_id)
      end


      def available_quantity
        if product_id.present? && bar_code.blank?
          find_product.available_quantity
        elsif purchase_order_line_item_id.present? && bar_code.present?
          find_purchase_order_line_item.available_quantity
        end
      end


      def quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if uantity.to_f > available_quantity
      end

    end
  end
end
