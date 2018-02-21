module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItemProcessing
     include ActiveModel::Model
      attr_accessor :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :bar_code

      def process!
        ActiveRecord::Base.transaction do
          process_line_item
        end
      end

      private
      def process_line_item
        line_item = find_cart.purchase_order_line_items.create!(
                                    quantity: quantity,
                                    unit_cost: unit_cost,
                                    total_cost: total_cost,
                                    unit_of_measurement_id: unit_of_measurement_id,
                                    product_id: product_id,
                                    bar_code: bar_code
                                    )
      end
      def find_cart
        Cart.find_by_id(cart_id)
      end
    end
  end
end
