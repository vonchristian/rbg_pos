module StoreFrontModule
  module LineItems
    class StockTransferOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id,
                    :quantity,
                    :cart_id,
                    :product_id,
                    :barcode,
                    :adjustment
      validates :quantity, numericality: { greater_than: 0.1 }
      validate :quantity_is_less_than_or_equal_to_available_quantity?
      def process!
        ActiveRecord::Base.transaction do
          process_stock_transfer_order_line_item
        end
      end

      private
      def process_stock_transfer_order_line_item
        requested_quantity = converted_quantity
        find_product.purchases.order(created_at: :asc).available.each do |purchase|
          stock_transfer = find_cart.stock_transfer_order_line_items.create!(
            quantity:                 quantity_for(purchase, requested_quantity),
            unit_cost:                purchase.purchase_cost,
            total_cost:               total_cost_for(purchase, quantity),
            unit_of_measurement:      find_product.base_measurement,
            product_id:               product_id
            )
          requested_quantity -= stock_transfer.quantity
          break if requested_quantity.zero?
        end
      end

      def quantity_for(purchase, requested_quantity)
        if purchase.available_quantity >= BigDecimal.new(requested_quantity)
          BigDecimal.new(requested_quantity)
        else
          purchase.available_quantity.to_f
        end
      end

      def total_cost_for(purchase, requested_quantity)
        purchase.purchase_cost * quantity_for(purchase, requested_quantity)
      end

      def converted_quantity
        find_unit_of_measurement.conversion_multiplier * quantity.to_f
      end
      def find_unit_of_measurement
        find_product.unit_of_measurements.find_by_id(unit_of_measurement_id)
      end
      def find_product
        Product.find_by_id(product_id)
      end
      def available_quantity
        if product_id.present? && barcode.blank?
          find_product.available_quantity
        elsif purchase_order_line_item_id.present? && barcode.present?
          find_purchase_order_line_item.available_quantity
        end
      end
      def find_cart
        Cart.find_by_id(cart_id)
      end

      def quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if converted_quantity.to_f > available_quantity
      end
    end
  end
end
