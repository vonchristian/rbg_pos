module StoreFrontModule
  module Orders 
    module StockTransferOrders 
      class AdditionalLineItem 
        include ActiveModel::Model 
        
        attr_accessor :cart_id, :stock_id, :product_id, :quantity, :employee_id, :unit_cost, :unit_of_measurement_id, :bar_code
        
        def process!
          if valid?
            ApplicationRecord.transaction do 
              create_line_item
            end 
          end 
        end 

        private 
        def create_line_item
          find_cart.purchase_order_line_items.create!(
            quantity: quantity,
            unit_cost: unit_cost,
            total_cost: total_cost,
            stock_id: stock_id, 
            product_id: product_id,
            unit_of_measurement_id: unit_of_measurement_id,
            bar_code: bar_code
          )
        end 
        def find_cart
          Cart.find(cart_id)
        end 

        def total_cost
          quantity.to_f * unit_cost.to_f 
        end 

      end 
    end 
  end 
end 