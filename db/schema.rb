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

ActiveRecord::Schema.define(version: 20170803125006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "account_code"
    t.boolean "contra", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_code"], name: "index_accounts_on_account_code", unique: true
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
    t.index ["account_id", "entry_id"], name: "index_amounts_on_account_id_and_entry_id"
    t.index ["account_id"], name: "index_amounts_on_account_id"
    t.index ["entry_id", "account_id"], name: "index_amounts_on_entry_id_and_account_id"
    t.index ["entry_id"], name: "index_amounts_on_entry_id"
    t.index ["type"], name: "index_amounts_on_type"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "entries", force: :cascade do |t|
    t.string "reference_number"
    t.datetime "entry_date"
    t.string "commercial_document_type"
    t.bigint "commercial_document_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_on_commercial_document_entry"
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
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["stock_id"], name: "index_line_items_on_stock_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "mode_of_payment"
    t.decimal "discount_amount"
    t.decimal "cash_tendered"
    t.decimal "change"
    t.decimal "total_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_cost_less_discount"
    t.index ["order_id"], name: "index_payments_on_order_id"
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
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["name"], name: "index_products_on_name", unique: true
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
    t.string "name"
    t.index ["name"], name: "index_stocks_on_name", unique: true
    t.index ["product_id"], name: "index_stocks_on_product_id"
    t.index ["supplier_id"], name: "index_stocks_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "business_name"
    t.string "owner_name"
    t.string "address"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_name"], name: "index_suppliers_on_business_name", unique: true
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "amounts", "accounts"
  add_foreign_key "amounts", "entries"
  add_foreign_key "job_orders", "customers"
  add_foreign_key "job_orders", "units"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "stocks"
  add_foreign_key "orders", "customers"
  add_foreign_key "payments", "orders"
  add_foreign_key "products", "categories"
  add_foreign_key "stocks", "products"
  add_foreign_key "stocks", "suppliers"
  add_foreign_key "units", "customers"
end
