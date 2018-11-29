module StoreFrontModule
  module LineItems
    class OtherSalesItemProcessing
      include ActiveModel::Model
      attr_accessor :amount, :description, :date, :reference_number, :cart_id

      def process!
        ActiveRecord::Base.transaction do
          create_other_sales_item
        end
      end

      private
      def create_other_sales_item
        find_cart.other_sales_line_items.create!(
          amount:           amount,
          description:      description,
          date:             date,
          reference_number: reference_number
        )
      end
      def find_cart
        Cart.find(cart_id)
      end
    end
  end
end
