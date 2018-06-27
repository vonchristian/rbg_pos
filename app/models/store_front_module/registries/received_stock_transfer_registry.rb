module StoreFrontModule
  module Registries
    class ReceivedStockTransferRegistry < Registry
      has_many :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'registry_id', dependent: :destroy

      def parse_for_records
        book = Spreadsheet.open(spreadsheet.path)
        sheet = book.worksheet(0)
        transaction do
          sheet.each 1 do |row|
            if !row[0].nil?
              create_or_find_product(row)
              create_or_find_line_item(row)
              find_or_create_selling_price(row)
            end
          end
        end
      end

      def create_or_find_product(row)
        if product = Product.find_by(name: row[0]).present?
          product
        else
          Product.find_or_create_by(name: row[0], category: find_category(row))
        end
      end

      def create_or_find_line_item(row)
        if quantity(row).present? && quantity(row) > 0
          StoreFrontModule::LineItems::PurchaseOrderLineItem.create!(
            quantity: quantity(row),
            unit_cost: unit_cost(row),
            total_cost: total_cost(row),
            product: find_product(row),
            unit_of_measurement: unit_of_measurement(row),
            bar_code: bar_code(row),
            registry_id: self.id)
        end
      end

      def quantity(row)
        row[1].to_i
      end
      def find_category(row)
        Category.find_or_create_by(name: row[10])
      end

      def unit_cost(row)
        row[2]
      end

      def total_cost(row)
        row[3]
      end

      def find_product(row)
        Product.find_by(name: row[0])
      end

      def bar_code(row)
        normalized_barcode(row)
      end

      def base_measurement(row)
        row[7] || true
      end

      def conversion_quantity(row)
        row[8] || 1
      end

      def unit_quantity(row)
        row[9] || 1
      end

      def unit_of_measurement(row)
        find_product(row).unit_of_measurements.find_or_create_by(
          unit_code: row[4],
          base_measurement: base_measurement(row),
          conversion_quantity: conversion_quantity(row),
          quantity: unit_quantity(row)
          )
      end
      def find_or_create_selling_price(row)
        find_product(row).selling_prices.create(price: row[6], unit_of_measurement: find_unit_of_measurement(row))
      end
      def find_unit_of_measurement(row)
        find_product(row).unit_of_measurements.find_by(unit_code: row[4], base_measurement: base_measurement(row),  conversion_quantity: conversion_quantity(row),
          quantity: unit_quantity(row))
      end
      def normalized_barcode(row)
        if row[5].to_s.include?(".")
          row[5].to_s.chop.gsub(".", "")
        else
          row[5].to_s
        end
      end
    end
  end
end
