module StoreFrontModule
  module Orders 
    module StockTransferOrders 
      class AdditionalLineItemOrderProcessing 
        include ActiveModel::Model

        attr_accessor :cart_id, :stock_transfer_order_id 

        def process!
          if valid?
            ApplicationRecord.transaction do 
              create_stocks
              add_items_to_order 
              remove_cart_reference 
            end 
          end 
        end 

        private 
        def add_items_to_order 
          find_stock_transfer_order.purchase_order_line_items << find_cart.purchase_order_line_items 
        end 
        def create_stocks 
          find_cart.stock_transfer_order_line_items.each do |line_item|
            ::StoreFronts::StockTransfers::StockCreation.new(line_item: line_item, destination_store_front: find_stock_transfer_order.destination_store_front).create_stock!
          end 
        end 

        def find_stock_transfer_order
          StoreFrontModule::Orders::PurchaseOrder.find(stock_transfer_order_id)
        end 
        def find_cart
          Cart.find(cart_id)
        end 
        def remove_cart_reference
          find_cart.purchase_order_line_items.each do |line_item|
            line_item.cart_id = nil 
            line_item.save!
          end 
        end
      end 
    end 
  end 
end 
