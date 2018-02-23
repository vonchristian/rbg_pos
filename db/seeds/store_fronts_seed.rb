

lagawe_merchandise_inventory_account  = AccountingModule::Asset.create(account_code: 118101,  name: "Merchandise Inventory (Lagawe)")
lamut_merchandise_inventory_account   = AccountingModule::Asset.create(account_code: 118102,  name: "Merchandise Inventory (Lamut)")
bambang_merchandise_inventory_account = AccountingModule::Asset.create(account_code: 118103,  name: "Merchandise Inventory (Bambang)")

lagawe_sales_account  = AccountingModule::Revenue.create(account_code: 403101, name: 'Sales (Lagawe)')
lamut_sales_account   = AccountingModule::Revenue.create(account_code: 403102, name: 'Sales (Lamut)')
bambang_sales_account = AccountingModule::Revenue.create(account_code: 403103, name: 'Sales (Bambang)')

lagawe_sales_return_account = AccountingModule::Revenue.create(account_code: 403301, name: 'Sales Returns and Allowances (Lagawe)', contra: true)
lamut_sales_return_account = AccountingModule::Revenue.create(account_code: 403302, name: 'Sales Returns and Allowances (Lamut)', contra: true)
bambang_sales_return_account = AccountingModule::Revenue.create(account_code: 403303, name: 'Sales Returns and Allowances (Bambang)', contra: true)

lagawe_sales_discount_account = AccountingModule::Revenue.create(account_code: 403401, name: 'Sales Discounts (Lagawe)', contra: true)
lamut_sales_discount_account = AccountingModule::Revenue.create(account_code: 403402, name: 'Sales Discounts (Lamut)', contra: true)
bambang_sales_discount_account = AccountingModule::Revenue.create(account_code: 403403, name: 'Sales Discounts (Bambang)', contra: true)

lagawe_cost_of_goods_sold_account = AccountingModule::Expense.create(account_code: 500001, name: 'Cost of Goods Sold (Lagawe)')
lamut_cost_of_goods_sold_account = AccountingModule::Expense.create(account_code: 500002, name: 'Cost of Goods Sold (Lamut)')
bambang_cost_of_goods_sold_account = AccountingModule::Expense.create(account_code: 500003, name: 'Cost of Goods Sold (Bambang)')

business = Business.create(name: "RBG Computers, Cellshop and Enterprises")
lagawe = StoreFront.create!(
  name: "Lagawe",
  business: business,
  merchandise_inventory_account: lagawe_merchandise_inventory_account,
  sales_account: lagawe_sales_account,
  sales_return_account: lagawe_sales_return_account,
  sales_discount_account: lagawe_sales_discount_account,
  cost_of_goods_sold_account: lagawe_cost_of_goods_sold_account)

lamut = StoreFront.create(
  name: "Lamut",
  business: business,
  merchandise_inventory_account: lamut_merchandise_inventory_account,
  sales_account: lamut_sales_account,
  sales_return_account: lamut_sales_return_account,
  sales_discount_account: lamut_sales_discount_account,
  cost_of_goods_sold_account: lamut_cost_of_goods_sold_account)

lagawe = StoreFront.create(
  name: "Bambang",
  business: business,
  merchandise_inventory_account: bambang_merchandise_inventory_account,
  sales_account: bambang_sales_account,
  sales_return_account: bambang_sales_return_account,
  sales_discount_account: bambang_sales_discount_account,
  cost_of_goods_sold_account: bambang_cost_of_goods_sold_account)
