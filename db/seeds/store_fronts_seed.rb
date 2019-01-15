

lagawe_merchandise_inventory_account  = AccountingModule::Asset.create!(account_code: 118101,  name: "Merchandise Inventory (Lagawe)")
lamut_merchandise_inventory_account   = AccountingModule::Asset.create!(account_code: 118102,  name: "Merchandise Inventory (Lamut)")
bambang_merchandise_inventory_account = AccountingModule::Asset.create!(account_code: 118103,  name: "Merchandise Inventory (Bambang)")

lagawe_receivable_account  = AccountingModule::Asset.create!(account_code: 118104,  name: "Accounts Receivable (Lagawe)")
lamut_receivable_account   = AccountingModule::Asset.create!(account_code: 118105,  name: "Accounts Receivable (Lamut)")
bambang_receivable_account = AccountingModule::Asset.create!(account_code: 118106,  name: "Accounts Receivable (Bambang)")




lagawe_sales_account  = AccountingModule::Revenue.create!(account_code: 403101, name: 'Sales (Lagawe)')
lamut_sales_account   = AccountingModule::Revenue.create!(account_code: 403102, name: 'Sales (Lamut)')
bambang_sales_account = AccountingModule::Revenue.create!(account_code: 403103, name: 'Sales (Bambang)')

lagawe_sales_return_account = AccountingModule::Revenue.create!(account_code: 403301, name: 'Sales Returns and Allowances (Lagawe)', contra: true)
lamut_sales_return_account = AccountingModule::Revenue.create!(account_code: 403302, name: 'Sales Returns and Allowances (Lamut)', contra: true)
bambang_sales_return_account = AccountingModule::Revenue.create!(account_code: 403303, name: 'Sales Returns and Allowances (Bambang)', contra: true)

lagawe_sales_discount_account = AccountingModule::Revenue.create!(account_code: 403401, name: 'Sales Discounts (Lagawe)', contra: true)
lamut_sales_discount_account = AccountingModule::Revenue.create!(account_code: 403402, name: 'Sales Discounts (Lamut)', contra: true)
bambang_sales_discount_account = AccountingModule::Revenue.create!(account_code: 403403, name: 'Sales Discounts (Bambang)', contra: true)

lagawe_cost_of_goods_sold_account = AccountingModule::Expense.create!(account_code: 500001, name: 'Cost of Goods Sold (Lagawe)')
lamut_cost_of_goods_sold_account = AccountingModule::Expense.create!(account_code: 500002, name: 'Cost of Goods Sold (Lamut)')
bambang_cost_of_goods_sold_account = AccountingModule::Expense.create!(account_code: 500003, name: 'Cost of Goods Sold (Bambang)')

lagawe_internal_use_account = AccountingModule::Expense.create!(account_code: 500004, name: 'Internal Use Expenses (Lagawe)')
lamut_internal_use_account = AccountingModule::Expense.create!(account_code: 500005, name: 'Internal Use Expenses (Lamut)')
bambang_internal_use_account = AccountingModule::Expense.create!(account_code: 500006, name: 'Internal Use Expenses (Bambang)')

lagawe_purchase_return_account = AccountingModule::Expense.create!(account_code: 511301, name: 'Purchase Returns (Lagawe)', contra: true)
lamut_purchase_return_account = AccountingModule::Expense.create!(account_code: 511302, name: 'Purchase Returns (Lamut)', contra: true)
bambang_purchase_return_account = AccountingModule::Expense.create!(account_code: 511303, name: 'Purchase Returns (Bambang)', contra: true)

lagawe_spoilage_account = AccountingModule::Expense.create!(account_code: 723401, name: 'Spoilages (Lagawe)')
lamut_spoilage_account = AccountingModule::Expense.create!(account_code: 723402, name: 'Spoilages (Lamut)')
bambang_spoilage_account = AccountingModule::Expense.create!(account_code: 723403, name: 'Spoilages (Bambang)')



business = Business.find_by(name: "RBG Computers, Cellshop and Enterprises")
lagawe = StoreFront.create!(
  name: "Lagawe",
  business: business,
  merchandise_inventory_account: lagawe_merchandise_inventory_account,
  sales_account: lagawe_sales_account,
  sales_return_account: lagawe_sales_return_account,
  sales_discount_account: lagawe_sales_discount_account,
  cost_of_goods_sold_account: lagawe_cost_of_goods_sold_account,

  receivable_account: lagawe_receivable_account,
  internal_use_account: lagawe_internal_use_account,
  purchase_return_account: lagawe_purchase_return_account,
  spoilage_account: lagawe_spoilage_account

  )

lamut = StoreFront.create!(
  name: "Lamut",
  business: business,
  merchandise_inventory_account: lamut_merchandise_inventory_account,
  sales_account: lamut_sales_account,
  sales_return_account: lamut_sales_return_account,
  sales_discount_account: lamut_sales_discount_account,
  cost_of_goods_sold_account: lamut_cost_of_goods_sold_account,
  receivable_account: lamut_receivable_account,
  internal_use_account: lamut_internal_use_account,
  purchase_return_account: lamut_purchase_return_account,
  spoilage_account: lamut_spoilage_account)

lagawe = StoreFront.create(
  name: "Bambang",
  business: business,
  merchandise_inventory_account: bambang_merchandise_inventory_account,
  sales_account: bambang_sales_account,
  sales_return_account: bambang_sales_return_account,
  sales_discount_account: bambang_sales_discount_account,
  cost_of_goods_sold_account: bambang_cost_of_goods_sold_account,
  receivable_account: bambang_receivable_account,
  internal_use_account: bambang_internal_use_account,
  purchase_return_account: bambang_purchase_return_account,
  spoilage_account: bambang_spoilage_account)
