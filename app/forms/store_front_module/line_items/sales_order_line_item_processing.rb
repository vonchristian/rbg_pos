module StoreFrontModule
  module LineItems
    class SalesOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id,
                    :quantity,
                    :cart_id,
                    :product_id,
                    :unit_cost,
                    :bar_code,
                    :store_front_id,
                    :stock_id
      validates :quantity, numericality: { greater_than: 0.1 }

      validate :quantity_is_less_than_or_equal_to_available_quantity?
      def process!
        ActiveRecord::Base.transaction do
          process_sales_order_line_item
        end
      end

      private
      def process_sales_order_line_item
        decrease_stock_quantity
      end

      def decrease_stock_quantity
        find_cart.sales_order_line_items.create!(
        stock:               find_stock,
        quantity:            quantity,
        unit_cost:           selling_cost,
        total_cost:          set_total_cost,
        product:             find_stock.product,
        unit_of_measurement: find_unit_of_measurement,
        bar_code:            find_stock.barcode)
      end



      def converted_quantity
        find_unit_of_measurement.conversion_multiplier * quantity.to_f
      end

      def find_cart
        Cart.find(cart_id)
      end

      def selling_cost
        if unit_cost.present?
          unit_cost.to_f
        else
          find_unit_of_measurement.price_for_store_front(store_front: find_store_front)
        end
      end

      def set_total_cost
        (selling_cost * quantity.to_f)
      end

      def total_cost_for(purchase, requested_quantity)
        purchase.purchase_cost * quantity_for(purchase, requested_quantity)
      end

      def find_unit_of_measurement
        find_stock.unit_of_measurement
      end

      def find_product
        find_stock.product
      end

      def find_store_front
        StoreFront.find(store_front_id)
      end

      def find_stock
        find_store_front.stocks.find(stock_id)
      end

      def available_quantity
        find_stock.balance
      end

      def quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if converted_quantity.to_f > available_quantity
      end
    end
  end
end
