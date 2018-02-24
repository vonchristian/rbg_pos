BlockChain for  ecommerce


Real Property Tax Assessment System
Real Property Tax Billing And Collecting System
General Revenue Collection System
Statement of Expenditures and Check Writing System


Namespace to order_processings
Namespace to line_item_processings

add unit of measurement to stocks creation
add unit of measurement to sale line item creation
migrate stocks to purchase_order_line_items
migrate line_items_to sales_order_line_items
add unit of measurement to uploading of stocks
migrate spare_parts_to work_order_line_items

migrate stocks.last.unit_cost to product base_measurement.unit_cost
migrate stocks.last.unit_ to product base_measurement.unit_code

migrate work orders to subclass Order


do not


create sales return order feature
create purchase return order feature

migration to create unit of measurement

Product.each do |product|
  product.unit_of_measurements.create(
  unit_code: product.unit,
  description: description
  quantity: 1,
  base_measurement: true
  selling_prices_attributes: [price: product.stocks.last.try(:unit_cost)]
  )
  end
