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

      def process!
        ActiveRecord::Base.transaction do
          process_line_item
        end
      end

      private
      def process_line_item
        find_cart.purchase_return_order_line_items.create!(
        quantity: quantity,
        unit_cost: purchase_cost,
        total_cost: quantity.to_f * purchase_cost,
        unit_of_measurement_id: unit_of_measurement_id,
        product_id: product_id,
        bar_code: bar_code,
        purchase_order_line_item_id: purchase_order_line_item_id
        )
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

    end
  end
end
