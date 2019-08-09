module RepairServicesModule
  class RepairServiceOrderLineItemProcessing
    include ActiveModel::Model
    attr_accessor :unit_of_measurement_id,
                    :quantity,
                    :cart_id,
                    :product_id,
                    :unit_cost,
                    :bar_code,
                    :stock_id,
                    :work_order_id
      validates :quantity, numericality: { greater_than: 0.1 }
      validate :quantity_is_less_than_or_equal_to_available_quantity?
      def find_stock
        StoreFronts::Stock.find(stock_id)
      end

      def process!
        ActiveRecord::Base.transaction do
          process_sales_order_line_item
        end
      end

      private
      def find_work_order
        WorkOrder.find(work_order_id)
      end

      def find_store_front
        find_work_order.store_front
      end

      def process_sales_order_line_item
        decrease_purchase_line_item_quantity
      end


      def decrease_purchase_line_item_quantity
        sales = find_cart.sales_order_line_items.create!(
          stock:      find_stock,
          quantity:   quantity,
          unit_cost:  selling_cost,
          total_cost: set_total_cost,
          product: find_stock.product,
          unit_of_measurement: find_unit_of_measurement,
          bar_code: bar_code
          )
      end


      def find_cart
        Cart.find(cart_id)
      end

      def selling_cost
        if unit_cost.present?
          unit_cost.to_f
        else
          find_unit_of_measurement.price
        end
      end

      def set_total_cost
        (selling_cost * quantity.to_f)
      end


      def find_unit_of_measurement
        find_stock.unit_of_measurement
      end

      def find_product
        Product.find(product_id)
      end

      def available_quantity
        find_stock.balance_for_cart(find_cart)
      end

      def quantity_is_less_than_or_equal_to_available_quantity?
        errors[:quantity] << "exceeded available quantity" if quantity.to_f > available_quantity
      end
    end
  end
