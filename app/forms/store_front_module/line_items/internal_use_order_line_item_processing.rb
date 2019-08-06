module StoreFrontModule
  module LineItems
    class InternalUseOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id,
                    :quantity,
                    :cart_id,
                    :product_id,
                    :bar_code,
                    :stock_id
      validates :quantity, numericality: { greater_than: 0.1 }
      validate :quantity_is_less_than_or_equal_to_available_quantity?
      def process!
        ActiveRecord::Base.transaction do
          process_line_item
        end
      end

      private
      def process_line_item
        decrease_purchase_line_item_quantity
      end

      def decrease_purchase_line_item_quantity
        find_cart.internal_use_order_line_items.create!(
          quantity:   quantity,
          unit_cost:  purchase_cost,
          total_cost: set_total_cost,
          product_id: find_stock.product,
          stock:     find_stock,
          unit_of_measurement: find_stock.unit_of_measurement)
      end

      def purchase_cost
        find_stock.last_purchase_cost
      end


      def set_total_cost
        find_stock.last_purchase_cost * converted_quantity.to_f
      end



      def converted_quantity
        find_unit_of_measurement.conversion_multiplier * quantity.to_f
      end
      def find_unit_of_measurement
        find_stock.unit_of_measurement
      end
      def find_product
        find_stock.product
      end

      def available_quantity
        find_stock.balance
      end
      def find_cart
        Cart.find(cart_id)
      end
      def find_stock
        ::StoreFronts::Stock.find(stock_id)
      end

      def quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if converted_quantity.to_f > available_quantity
      end
    end
  end
end
