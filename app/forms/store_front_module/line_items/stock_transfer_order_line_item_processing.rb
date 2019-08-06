module StoreFrontModule
  module LineItems
    class StockTransferOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id,
                    :quantity,
                    :cart_id,
                    :product_id,
                    :bar_code,
                    :selling_price,
                    :stock_id
      validates :quantity, numericality: { greater_than: 0.1 }
      validates :stock_id, presence: true
      validate :quantity_is_less_than_or_equal_to_available_quantity?
      def process!
        ActiveRecord::Base.transaction do
          process_line_item
        end
      end

      private
      def process_line_item
        decrease_stock_quantity
      end


      def decrease_stock_quantity
        purchase = find_stock
        transfer = find_cart.purchase_order_line_items.create!(
          quantity: quantity,
          unit_cost: purchase_cost,
          total_cost: set_total_cost,
          product: find_stock.product,
          stock: find_stock,
          unit_of_measurement: find_stock.unit_of_measurement,
          bar_code: bar_code
          )
        purchase.stock_transfers.create!(
            cart:                     find_cart,
            quantity:                 converted_quantity,
            unit_cost:                purchase.last_purchase_cost,
            total_cost:               total_cost_for(purchase),
            unit_of_measurement:      find_stock.unit_of_measurement,
            product_id:               product_id)
      end



      def total_cost_for(purchase)
        purchase_cost * quantity.to_f
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
      def purchase_cost
        find_stock.last_purchase_cost
      end
       def set_total_cost
        purchase_cost * converted_quantity.to_f
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
