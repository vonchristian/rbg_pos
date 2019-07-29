module Suppliers
  class PurchaseLineItem
    include ActiveModel::Model
    attr_accessor :quantity, :unit_cost, :total_cost, :selling_price, :unit_of_measurement_id, :product_id, :barcode, :cart_id, :store_front_id, :selling_price
    validates :quantity, :unit_of_measurement_id, presence: true
    def process!
      if valid?
        ActiveRecord::Base.transaction do
          process_line_item
        end
      end
    end

    private
    def process_line_item
      create_stock
      create_selling_price
    end

    def create_stock
      stock = find_product.stocks.create!(store_front_id: store_front_id, barcode: barcode, unit_of_measurement_id: unit_of_measurement_id)
      create_purchase(stock)
    end
    def create_purchase(stock)
      stock.purchases.create!(
      cart_id:                cart_id,
      stock:                  stock,
      quantity:               quantity,
      unit_cost:              unit_cost,
      total_cost:             total_cost,
      bar_code:               barcode,
      unit_of_measurement_id: unit_of_measurement_id)
    end
    def create_selling_price
      find_product.selling_prices.create!(
          price: selling_price,
          store_front_id: store_front_id,
          unit_of_measurement_id: unit_of_measurement_id
        )
    end

    def find_product
      Product.find(product_id)
    end
  end
end
