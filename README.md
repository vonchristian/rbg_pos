check delete of cart
stock transfer
  origi


Add sales on employee show
add purchases/sales/returns/on excel


work order
sales order
sales order destroy
destroy entry for work order

1. @main - cannot upload transfers from branches #DONE - check columns are present && xls file
2. Can't delete uploaded error purchases DONE
3. Cannot edit product info - cant edit barcodes DONE - product -> stocks -> Edit
4. Can't edit cash transfers, remittances (nu adda double entry madik madelete) DONE - idelete mu jy entry ijy employee -> journal entries
5. New other sales-agparang kuma idjay ORdER-Sales, tas mabalin kuma agdelete ti new other sales DONE
6. Order -sales : rumwar amin kuma cash sales, credit sales en acct payments tapnu mamonitor nu mairecrecord amin nga payments DONE - ada link sidebar -> CREDIT PAYMENTS
7. On chek payments ti offices - nu pasukan diay tax accounts ket madi mai-deduct idiay gross amount..ag autocompute kuma-tas madi ngy agzero diay acct nu diay net amount ti cheke ti ipasok. Tas diay summary ti account-agparang kuma diay tax/discounts DONE -> jy full amount ienter jy AMOUNT field
8. Madik makadelete ti parts nga nai-add ti services - IAYUS KU PAY
9. Services - rumwar kuma diay Charge invoice #s tapnu nalaku agpost payments ti services esp nu madi da naikarga diay service report # DONE -> mabali isearch metlang ti CI number ijy search bar ti services
10. Account description-mabalin ba mahugot from sales para d na kelangan itype ulit description pag nagpost payments - AYNA NGA BANDA ATUY?
11. Sa orders, delete button beside every item para d lahat ng items kelangan ide delete lahat-ung item lang na kelangan alisin ang idelete #NOT POSSIBLE - jy entry gamin ti accounting
12. On price adjustments - mabalin metlang ikan box para da dealers price adjustment - INYA IKASTA NA ATUY?
13. Sales return - madi met maikkat idjay acct ti customer diay item nga naireturn IAYUS KU PAY
14. paki ckeck nu ada CASH ON HAND ACCOUNT ni Elmie jy settings
rm /usr/local/var/postgres/postmaster.pid

Engine for Repair Section
Engine for Store
Engine for Accounting


BIR Config
  VatRegistration VAT or NON-VAT

OR:
  Official Receipt
  Total Sales Due
  Less Witholding Tax
  Total Payment
  Senior Citizen / Person with Disabilities Discount

ADD PRODUCT PRICE AND UOM TO EXCEL DOWNLOAD IN SERVER


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
