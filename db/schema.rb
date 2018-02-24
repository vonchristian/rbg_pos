# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180224080034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessories", force: :cascade do |t|
    t.bigint "product_unit_id"
    t.decimal "quantity"
    t.string "description"
    t.string "serial_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "work_order_id"
    t.index ["product_unit_id"], name: "index_accessories_on_product_unit_id"
    t.index ["work_order_id"], name: "index_accessories_on_work_order_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "account_code"
    t.boolean "contra", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "main_account_id"
    t.boolean "active", default: true
    t.index ["account_code"], name: "index_accounts_on_account_code", unique: true
    t.index ["main_account_id"], name: "index_accounts_on_main_account_id"
    t.index ["name"], name: "index_accounts_on_name", unique: true
    t.index ["type"], name: "index_accounts_on_type"
  end

  create_table "amounts", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "entry_id"
    t.decimal "amount"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commercial_document_type"
    t.bigint "commercial_document_id"
    t.index ["account_id", "entry_id"], name: "index_amounts_on_account_id_and_entry_id"
    t.index ["account_id"], name: "index_amounts_on_account_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_amounts"
    t.index ["entry_id", "account_id"], name: "index_amounts_on_entry_id_and_account_id"
    t.index ["entry_id"], name: "index_amounts_on_entry_id"
    t.index ["type"], name: "index_amounts_on_type"
  end

  create_table "branches", force: :cascade do |t|
    t.bigint "business_id"
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_branches_on_business_id"
  end

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.string "owner"
    t.string "address"
    t.string "email"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cash_payments", force: :cascade do |t|
    t.decimal "cash_tendered"
    t.decimal "cash_change"
    t.string "cash_paymentable_type"
    t.bigint "cash_paymentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "discount_amount"
    t.index ["cash_paymentable_type", "cash_paymentable_id"], name: "index_paymentable_on_cash_payments"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "contact_number"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "enable_interest", default: false
  end

  create_table "entries", force: :cascade do |t|
    t.string "reference_number"
    t.datetime "entry_date"
    t.string "commercial_document_type"
    t.bigint "commercial_document_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entry_type"
    t.bigint "user_id"
    t.bigint "recorder_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_on_commercial_document_entry"
    t.index ["entry_type"], name: "index_entries_on_entry_type"
    t.index ["recorder_id"], name: "index_entries_on_recorder_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "type"
    t.string "number"
    t.string "invoiceable_type"
    t.bigint "invoiceable_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoiceable_type", "invoiceable_id"], name: "index_invoices_on_invoiceable_type_and_invoiceable_id"
    t.index ["type"], name: "index_invoices_on_type"
  end

  create_table "job_orders", force: :cascade do |t|
    t.bigint "unit_id"
    t.datetime "date"
    t.integer "status"
    t.text "remarks"
    t.integer "actions_taken"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_job_orders_on_customer_id"
    t.index ["status"], name: "index_job_orders_on_status"
    t.index ["unit_id"], name: "index_job_orders_on_unit_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "stock_id"
    t.decimal "unit_cost"
    t.decimal "total_cost"
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.decimal "markup_amount", default: "0.0"
    t.bigint "work_order_id"
    t.bigint "user_id"
    t.string "search"
    t.bigint "stock_transfer_id"
    t.string "type"
    t.bigint "referenced_line_item_id"
    t.bigint "product_id"
    t.bigint "unit_of_measurement_id"
    t.bigint "sales_order_line_item_id"
    t.bigint "purchase_order_line_item_id"
    t.string "bar_code"
    t.string "commercial_document_type"
    t.bigint "commercial_document_id"
    t.string "referencer_type"
    t.bigint "referencer_id"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_line_items"
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
    t.index ["purchase_order_line_item_id"], name: "index_line_items_on_purchase_order_line_item_id"
    t.index ["referenced_line_item_id"], name: "index_line_items_on_referenced_line_item_id"
    t.index ["referencer_type", "referencer_id"], name: "index_line_items_on_referencer_type_and_referencer_id"
    t.index ["sales_order_line_item_id"], name: "index_line_items_on_sales_order_line_item_id"
    t.index ["stock_id"], name: "index_line_items_on_stock_id"
    t.index ["stock_transfer_id"], name: "index_line_items_on_stock_transfer_id"
    t.index ["type"], name: "index_line_items_on_type"
    t.index ["unit_of_measurement_id"], name: "index_line_items_on_unit_of_measurement_id"
    t.index ["user_id"], name: "index_line_items_on_user_id"
    t.index ["work_order_id"], name: "index_line_items_on_work_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
    t.string "reference_number"
    t.boolean "internal_use", default: false
    t.bigint "technician_id"
    t.string "description"
    t.string "barcode"
    t.string "search_term"
    t.string "type"
    t.string "commercial_document_type"
    t.bigint "commercial_document_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_orders"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["employee_id"], name: "index_orders_on_employee_id"
    t.index ["reference_number"], name: "index_orders_on_reference_number"
    t.index ["technician_id"], name: "index_orders_on_technician_id"
    t.index ["type"], name: "index_orders_on_type"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "mode_of_payment"
    t.decimal "discount_amount", default: "0.0"
    t.decimal "cash_tendered"
    t.decimal "change"
    t.decimal "total_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_cost_less_discount"
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "updateable_type"
    t.bigint "updateable_id"
    t.string "type"
    t.string "title"
    t.string "content"
    t.datetime "date"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_posts_on_type"
    t.index ["updateable_type", "updateable_id"], name: "index_posts_on_updateable_type_and_updateable_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "product_unit_service_charges", force: :cascade do |t|
    t.bigint "product_unit_id"
    t.bigint "service_charge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_unit_id"], name: "index_product_unit_service_charges_on_product_unit_id"
    t.index ["service_charge_id"], name: "index_product_unit_service_charges_on_service_charge_id"
  end

  create_table "product_units", force: :cascade do |t|
    t.string "description"
    t.string "model_number"
    t.string "serial_number"
    t.text "physical_condition"
    t.text "reported_problem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "service_number"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "unit"
    t.decimal "retail_price"
    t.decimal "wholesale_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.bigint "category_id"
    t.decimal "low_stock_count", default: "0.0"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "registries", force: :cascade do |t|
    t.string "spreadsheet_file_name"
    t.string "spreadsheet_content_type"
    t.integer "spreadsheet_file_size"
    t.datetime "spreadsheet_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["type"], name: "index_registries_on_type"
  end

  create_table "repair_services_front_configs", force: :cascade do |t|
    t.bigint "accounts_receivable_account_id"
    t.bigint "repair_services_front_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accounts_receivable_account_id"], name: "index_accounts_receivable_account_on_repair_services_config"
    t.index ["repair_services_front_id"], name: "index_repair_services_front_configs_on_repair_services_front_id"
  end

  create_table "repair_services_fronts", force: :cascade do |t|
    t.bigint "business_id"
    t.string "name"
    t.string "address"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_repair_services_fronts_on_business_id"
    t.index ["name"], name: "index_repair_services_fronts_on_name", unique: true
  end

  create_table "repairs", force: :cascade do |t|
    t.text "symptoms_observed"
    t.text "repair_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales_returns", force: :cascade do |t|
    t.bigint "line_item_id"
    t.integer "sales_return_type"
    t.datetime "date"
    t.string "remarks"
    t.bigint "order_id"
    t.decimal "quantity"
    t.string "name"
    t.string "barcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_item_id"], name: "index_sales_returns_on_line_item_id"
    t.index ["order_id"], name: "index_sales_returns_on_order_id"
    t.index ["sales_return_type"], name: "index_sales_returns_on_sales_return_type"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "selling_prices", force: :cascade do |t|
    t.decimal "price"
    t.bigint "unit_of_measurement_id"
    t.bigint "product_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_selling_prices_on_product_id"
    t.index ["unit_of_measurement_id"], name: "index_selling_prices_on_unit_of_measurement_id"
  end

  create_table "service_charges", force: :cascade do |t|
    t.string "description"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "charge_type"
    t.index ["charge_type"], name: "index_service_charges_on_charge_type"
  end

  create_table "stock_transfers", force: :cascade do |t|
    t.bigint "stock_id"
    t.datetime "date"
    t.decimal "quantity"
    t.bigint "destination_branch_id"
    t.bigint "origin_branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
    t.index ["destination_branch_id"], name: "index_stock_transfers_on_destination_branch_id"
    t.index ["employee_id"], name: "index_stock_transfers_on_employee_id"
    t.index ["origin_branch_id"], name: "index_stock_transfers_on_origin_branch_id"
    t.index ["stock_id"], name: "index_stock_transfers_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.decimal "unit_cost"
    t.bigint "product_id"
    t.bigint "supplier_id"
    t.decimal "total_cost"
    t.decimal "quantity"
    t.datetime "date"
    t.string "barcode"
    t.integer "mode_of_payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "retail_price"
    t.decimal "wholesale_price"
    t.bigint "branch_id"
    t.integer "stock_type"
    t.bigint "origin_branch_id"
    t.string "name"
    t.bigint "registry_id"
    t.bigint "employee_id"
    t.index ["branch_id"], name: "index_stocks_on_branch_id"
    t.index ["employee_id"], name: "index_stocks_on_employee_id"
    t.index ["origin_branch_id"], name: "index_stocks_on_origin_branch_id"
    t.index ["product_id"], name: "index_stocks_on_product_id"
    t.index ["registry_id"], name: "index_stocks_on_registry_id"
    t.index ["stock_type"], name: "index_stocks_on_stock_type"
    t.index ["supplier_id"], name: "index_stocks_on_supplier_id"
  end

  create_table "store_front_configs", force: :cascade do |t|
    t.bigint "accounts_receivable_account_id"
    t.bigint "store_front_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accounts_receivable_account_id"], name: "index_store_front_configs_on_accounts_receivable_account_id"
    t.index ["store_front_id"], name: "index_store_front_configs_on_store_front_id"
  end

  create_table "store_fronts", force: :cascade do |t|
    t.bigint "business_id"
    t.bigint "merchandise_inventory_account_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.bigint "cost_of_goods_sold_account_id"
    t.bigint "sales_return_account_id"
    t.bigint "sales_account_id"
    t.bigint "sales_discount_account_id"
    t.index ["business_id"], name: "index_store_fronts_on_business_id"
    t.index ["cost_of_goods_sold_account_id"], name: "index_store_fronts_on_cost_of_goods_sold_account_id"
    t.index ["merchandise_inventory_account_id"], name: "index_store_fronts_on_merchandise_inventory_account_id"
    t.index ["name"], name: "index_store_fronts_on_name", unique: true
    t.index ["sales_account_id"], name: "index_store_fronts_on_sales_account_id"
    t.index ["sales_discount_account_id"], name: "index_store_fronts_on_sales_discount_account_id"
    t.index ["sales_return_account_id"], name: "index_store_fronts_on_sales_return_account_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "business_name"
    t.string "owner_name"
    t.string "address"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "accounts_payable_account_id"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["accounts_payable_account_id"], name: "index_suppliers_on_accounts_payable_account_id"
    t.index ["business_name"], name: "index_suppliers_on_business_name", unique: true
  end

  create_table "technician_work_orders", force: :cascade do |t|
    t.bigint "technician_id"
    t.bigint "work_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["technician_id"], name: "index_technician_work_orders_on_technician_id"
    t.index ["work_order_id"], name: "index_technician_work_orders_on_work_order_id"
  end

  create_table "unit_of_measurements", force: :cascade do |t|
    t.bigint "product_id"
    t.string "unit_code"
    t.string "description"
    t.decimal "quantity"
    t.decimal "conversion_quantity"
    t.boolean "base_measurement", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_unit_of_measurements_on_product_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "brand"
    t.string "model"
    t.string "serial_number"
    t.datetime "purchase_date"
    t.datetime "warranty_date"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_units_on_customer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name"
    t.string "last_name"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "designation"
    t.bigint "section_id"
    t.bigint "cash_on_hand_account_id"
    t.bigint "store_front_id"
    t.bigint "business_id"
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["business_id"], name: "index_users_on_business_id"
    t.index ["cash_on_hand_account_id"], name: "index_users_on_cash_on_hand_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["section_id"], name: "index_users_on_section_id"
    t.index ["store_front_id"], name: "index_users_on_store_front_id"
  end

  create_table "voucher_amounts", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "account_id"
    t.bigint "voucher_id"
    t.string "commercial_document_type"
    t.bigint "commercial_document_id"
    t.string "description"
    t.integer "amount_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_voucher_amounts_on_account_id"
    t.index ["amount_type"], name: "index_voucher_amounts_on_amount_type"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_voucher_amounts"
    t.index ["voucher_id"], name: "index_voucher_amounts_on_voucher_id"
  end

  create_table "vouchers", force: :cascade do |t|
    t.datetime "date"
    t.string "payee_type"
    t.bigint "payee_id"
    t.string "description"
    t.decimal "payable_amount"
    t.string "type"
    t.bigint "preparer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference_number"
    t.string "commercial_document_type"
    t.bigint "commercial_document_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_vouchers"
    t.index ["payee_type", "payee_id"], name: "index_vouchers_on_payee_type_and_payee_id"
    t.index ["preparer_id"], name: "index_vouchers_on_preparer_id"
    t.index ["reference_number"], name: "index_vouchers_on_reference_number", unique: true
    t.index ["type"], name: "index_vouchers_on_type"
  end

  create_table "warranties", force: :cascade do |t|
    t.string "barcode"
    t.string "name"
    t.string "remarks"
    t.decimal "quantity"
    t.bigint "sales_return_id"
    t.bigint "supplier_id"
    t.bigint "customer_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_warranties_on_customer_id"
    t.index ["sales_return_id"], name: "index_warranties_on_sales_return_id"
    t.index ["supplier_id"], name: "index_warranties_on_supplier_id"
  end

  create_table "warranty_releases", force: :cascade do |t|
    t.datetime "release_date"
    t.bigint "user_id"
    t.bigint "warranty_id"
    t.bigint "customer_id"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "quantity"
    t.index ["customer_id"], name: "index_warranty_releases_on_customer_id"
    t.index ["user_id"], name: "index_warranty_releases_on_user_id"
    t.index ["warranty_id"], name: "index_warranty_releases_on_warranty_id"
  end

  create_table "work_order_service_charges", force: :cascade do |t|
    t.bigint "service_charge_id"
    t.bigint "work_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["service_charge_id"], name: "index_work_order_service_charges_on_service_charge_id"
    t.index ["user_id"], name: "index_work_order_service_charges_on_user_id"
    t.index ["work_order_id"], name: "index_work_order_service_charges_on_work_order_id"
  end

  create_table "work_orders", force: :cascade do |t|
    t.integer "status"
    t.bigint "product_unit_id"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reported_problem"
    t.string "physical_condition"
    t.string "service_number"
    t.boolean "under_warranty", default: false
    t.integer "supplier_id"
    t.datetime "purchase_date"
    t.datetime "expiry_date"
    t.string "customer_name"
    t.string "product_name"
    t.bigint "section_id"
    t.bigint "store_front_id"
    t.index ["customer_id"], name: "index_work_orders_on_customer_id"
    t.index ["product_unit_id"], name: "index_work_orders_on_product_unit_id"
    t.index ["section_id"], name: "index_work_orders_on_section_id"
    t.index ["status"], name: "index_work_orders_on_status"
    t.index ["store_front_id"], name: "index_work_orders_on_store_front_id"
  end

  add_foreign_key "accessories", "product_units"
  add_foreign_key "accessories", "work_orders"
  add_foreign_key "accounts", "accounts", column: "main_account_id"
  add_foreign_key "amounts", "accounts"
  add_foreign_key "amounts", "entries"
  add_foreign_key "branches", "businesses"
  add_foreign_key "entries", "users"
  add_foreign_key "entries", "users", column: "recorder_id"
  add_foreign_key "job_orders", "customers"
  add_foreign_key "job_orders", "units"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "line_items", column: "purchase_order_line_item_id"
  add_foreign_key "line_items", "line_items", column: "referenced_line_item_id"
  add_foreign_key "line_items", "line_items", column: "sales_order_line_item_id"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "products"
  add_foreign_key "line_items", "stock_transfers"
  add_foreign_key "line_items", "stocks"
  add_foreign_key "line_items", "unit_of_measurements"
  add_foreign_key "line_items", "users"
  add_foreign_key "line_items", "work_orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "users", column: "employee_id"
  add_foreign_key "orders", "users", column: "technician_id"
  add_foreign_key "payments", "orders"
  add_foreign_key "posts", "users"
  add_foreign_key "product_unit_service_charges", "product_units"
  add_foreign_key "product_unit_service_charges", "service_charges"
  add_foreign_key "products", "categories"
  add_foreign_key "repair_services_front_configs", "accounts", column: "accounts_receivable_account_id"
  add_foreign_key "repair_services_front_configs", "repair_services_fronts"
  add_foreign_key "repair_services_fronts", "businesses"
  add_foreign_key "sales_returns", "line_items"
  add_foreign_key "sales_returns", "orders"
  add_foreign_key "stock_transfers", "branches", column: "destination_branch_id"
  add_foreign_key "stock_transfers", "branches", column: "origin_branch_id"
  add_foreign_key "stock_transfers", "stocks"
  add_foreign_key "stock_transfers", "users", column: "employee_id"
  add_foreign_key "stocks", "branches"
  add_foreign_key "stocks", "branches", column: "origin_branch_id"
  add_foreign_key "stocks", "products"
  add_foreign_key "stocks", "registries"
  add_foreign_key "stocks", "suppliers"
  add_foreign_key "stocks", "users", column: "employee_id"
  add_foreign_key "store_front_configs", "accounts", column: "accounts_receivable_account_id"
  add_foreign_key "store_front_configs", "store_fronts"
  add_foreign_key "store_fronts", "accounts", column: "cost_of_goods_sold_account_id"
  add_foreign_key "store_fronts", "accounts", column: "merchandise_inventory_account_id"
  add_foreign_key "store_fronts", "accounts", column: "sales_account_id"
  add_foreign_key "store_fronts", "accounts", column: "sales_discount_account_id"
  add_foreign_key "store_fronts", "accounts", column: "sales_return_account_id"
  add_foreign_key "store_fronts", "businesses"
  add_foreign_key "suppliers", "accounts", column: "accounts_payable_account_id"
  add_foreign_key "technician_work_orders", "users", column: "technician_id"
  add_foreign_key "technician_work_orders", "work_orders"
  add_foreign_key "unit_of_measurements", "products"
  add_foreign_key "units", "customers"
  add_foreign_key "users", "accounts", column: "cash_on_hand_account_id"
  add_foreign_key "users", "branches"
  add_foreign_key "users", "businesses"
  add_foreign_key "users", "sections"
  add_foreign_key "users", "store_fronts"
  add_foreign_key "voucher_amounts", "accounts"
  add_foreign_key "voucher_amounts", "vouchers"
  add_foreign_key "vouchers", "users", column: "preparer_id"
  add_foreign_key "warranties", "customers"
  add_foreign_key "warranties", "sales_returns"
  add_foreign_key "warranties", "suppliers"
  add_foreign_key "warranty_releases", "customers"
  add_foreign_key "warranty_releases", "users"
  add_foreign_key "warranty_releases", "warranties"
  add_foreign_key "work_order_service_charges", "service_charges"
  add_foreign_key "work_order_service_charges", "users"
  add_foreign_key "work_order_service_charges", "work_orders"
  add_foreign_key "work_orders", "customers"
  add_foreign_key "work_orders", "product_units"
  add_foreign_key "work_orders", "sections"
  add_foreign_key "work_orders", "store_fronts"
end
