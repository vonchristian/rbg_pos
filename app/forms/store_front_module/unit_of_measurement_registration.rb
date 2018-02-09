module StoreFrontModule
  class UnitOfMeasurementRegistration
    include ActiveModel::Model

    attr_accessor :unit_code, :quantity, :description, :base_measurement, :conversion_quantity, :product_id, :selling_price

    validates :unit_code, :quantity, :product_id, :selling_price, presence: true
    validates :selling_price, :quantity, numericality: true

    def register!
      ActiveRecord::Base.transaction do
        create_unit_of_measurement
      end
    end
    private
    def create_unit_of_measurement
      unit_of_measurement = find_product.unit_of_measurements.create(
      unit_code: unit_code,
      quantity: quantity,
      description: description,
      base_measurement: base_measurement,
      conversion_quantity: conversion_quantity
      )
      unit_of_measurement.selling_prices.create(
      price: selling_price,
      date: Date.today,
      product_id: product_id)
    end

    def find_product
      Product.find_by_id(product_id)
    end
  end
end
