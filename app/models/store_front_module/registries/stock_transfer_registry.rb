module StoreFrontModule
  module Registries
    class StockTransferRegistry < Registry
      has_many :delivered_stock_transfer_order_line_items, class_name: "StoreFrontModule::LineItems::DeliveredStockTransferOrderLineItem", foreign_key: 'registry_id'

      def parse_for_records
        product_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
        header = product_spreadsheet.row(1)
        (2..product_spreadsheet.last_row).each do |i|
          row = Hash[[header, product_spreadsheet.row(i)].transpose]

          create_or_find_product(row)
          create_or_find_line_item(row)
          find_or_create_selling_price(row)
        end
      end

      def create_or_find_product(row)
        if product = Product.find_by(name: row["Product Name"]).present?
          product
        else
          Product.find_or_create_by!(name: row["Product Name"], category: find_category(row), business:  employee.business)
        end
      end

      def create_or_find_line_item(row)
        if quantity(row).present? && quantity(row) > 0
          StoreFrontModule::LineItems::DeliveredStockTransferOrderLineItem.find_or_create_by!(
            store_front: employee.store_front,
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
        row["Quantity"].to_f
      end
      def find_category(row)
        Category.find_or_create_by(name: row["Category"])
      end

      def unit_cost(row)
        row["Unit Cost"].to_f
      end

      def total_cost(row)
        row["Total Cost"].to_f
      end

      def find_product(row)
        Product.find_or_create_by(name: row["Product Name"])
      end

      def bar_code(row)
        normalized_barcode(row)
      end

      def base_measurement(row)
        row["Base Measurement"] || true
      end

      def conversion_quantity(row)
        row["Conversion Quantity"] || 1
      end

      def unit_quantity(row)
        row["Quantity"] || 1
      end

      def unit_code(row)
        row["UOM"]
      end

      def selling_price(row)
        row["Selling Price"]
      end

      def unit_of_measurement(row)
        StoreFrontModule::UnitOfMeasurement.find_or_create_by!(
          unit_code:           unit_code(row),
          product:             find_product(row),
          base_measurement:    base_measurement(row),
          conversion_quantity: conversion_quantity(row),
          quantity:            1
          )
      end

      def find_or_create_selling_price(row)
        StoreFrontModule::SellingPrice.create!(
          price:               selling_price(row),
          product:             find_product(row),
          unit_of_measurement: unit_of_measurement(row))
    end

      def find_unit_of_measurement(row)
        find_product(row).unit_of_measurements.find_by(
          unit_code:           unit_code(row),
          base_measurement:    base_measurement(row),
          conversion_quantity: conversion_quantity(row),
          quantity:            unit_quantity(row))
      end
      def normalized_barcode(row)
        if row["Barcode"].to_s.include?(".")
          row["Barcode"].to_s.chop.gsub(".", "")
        else
          row["Barcode"].to_s
        end
      end
    end
  end
end
