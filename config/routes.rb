Rails.application.routes.draw do
  authenticate :user, -> (user) { user.proprietor? } do
    mount PgHero::Engine, at: "pghero"
  end
  unauthenticated :user do
    root :to => 'store#index', :constraints => lambda { |request| request.env['warden'].user.nil? }, as: :unauthenticated_root
  end
  devise_for :users, controllers: { sessions: 'users/sessions' , registrations: "users"}

  root :to => 'store#index', :constraints => lambda { |request| request.env['warden'].user.role == 'sales_clerk' if request.env['warden'].user }, as: :sales_department_root
  root :to => 'store#index', :constraints => lambda { |request| request.env['warden'].user.role == 'proprietor' if request.env['warden'].user }, as: :prop_department_root
  root :to => 'products#index', :constraints => lambda { |request| request.env['warden'].user.role == 'stock_custodian' if request.env['warden'].user }, as: :stocks_department_root
  root :to => 'computer_repair_section/dashboard#index', :constraints => lambda { |request| request.env['warden'].user.role == 'technician' if request.env['warden'].user }, as: :technician_root
  resources :store, only: [:index]
	resources :customers do
    resources :refunds,         only: [:new, :create],                module: :customers
    resources :payments,        only: [:new, :create],                module: :customers
    resources :orders,          only: [:index, :edit, :update],                       module: :customers
    resources :repair_services, only: [:index],                       module: :customers
    resources :account,         only: [:index],                       module: :customers
    resources :other_credits,   only: [:index, :show, :new, :create], module: :customers

  end
  resources :products do
    resources :unit_of_measurements, only: [:new, :create]
    match "/out_of_stock" => "products#out_of_stock",  via: [:get], on: :collection
    match "/low_on_stock" => "products#low_on_stock",  via: [:get], on: :collection

  	resources :stocks, only: [:index, :new, :create, :edit, :update], module: :products
    resources :orders, only: [:index], module: :products
  end
  resources :line_items, only: [:new, :create, :edit, :update]
  resources :orders, only: [:index, :show, :new, :create, :destroy]
  resources :carts, only: [:destroy]
  resources :categories, only: [:new, :create]
  resources :reports, only: [:index]
  resources :customer_registrations, only: [:new, :create]
  namespace :reports do
    resources :work_orders, only: [:index]
    resources :sales, only: [:index]
    resources :cash_receipts, only: [:index]
    resources :products, only: [:index]
    resources :accounts_receivables, only: [:index]

  end
  resources :accounting, only: [:index]
  namespace :accounting do
    resources :entries, only: [:show]
    resources :fund_transfers, only: [:new, :create]
    resources :remittances, only: [:new, :create]
    resources :expenses, only: [:new, :create]
  end

  resources :settings, only: [:index]
  resources :businesses, only: [:edit, :update]

  resources :supplier_registrations, only: [:new, :create]
  namespace :suppliers do
    resources :merge_accounts, only: [:new, :create]
  end
  resources :suppliers, only: [:index, :show, :edit, :update] do
    resources :purchase_orders, only: [:index], module: :suppliers
    resources :account, only: [:index], module: :suppliers
    resources :voucher_amounts, only: [:new, :create], module: :suppliers
    resources :vouchers, only: [:index, :create], module: :suppliers
    resources :payments, only: [:new, :create], module: :suppliers
  end
  resources :users, only: [:edit, :update]
  resources :registries, only: [:create, :show, :destroy]
  resources :employees, only: [:show, :edit, :update] do
    resources :remittances, only: [:new, :create], module: :employees
    resources :reports, only: [:index], module: :employees
    resources :sales, only: [:index], module: :employees
    resources :entries, only: [:index], module: :employees
  end
  resources :work_orders, only: [:index, :new, :create] do
    resources :payments, only: [:ew, :create], module: :work_orders
  end
  resources :work_order_statuses, only: [:edit, :update]
  namespace :computer_repair_section do
    resources :dashboard, only: [:index]
    resources :work_orders do
      resources :service_charges, only: [:new, :create], module: :work_orders
      resources :additional_charges, only: [:new, :create], module: :work_orders
      resources :spare_parts, only: [:new, :create, :destroy]
      resources :service_claim_tags, only: [:show]
      resources :payments, module: :work_orders, only: [:new, :create]
      resources :refunds, module: :work_orders, only: [:new, :create]
      resources :charge_invoices, only: [:new, :create], module: :work_orders
    end
    resources :work_order_service_charges, only: [:destroy]
    resources :work_order_updates, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :knowledge_center, only: [:index]
  resources :product_units, shallow: true do
    resources :accessories, only: [:new, :create]
  end

  resources :sections, only: [:new, :create]
  resources :other_sales, only: [:new, :create]
  resources :entries, only: [:destroy]
  resources :capital_withdrawals, only: [:new, :create]
  resources :accessories, only: [:destroy]
  resources :search_results, only: [:index]
  resources :customer_account_mergings, only: [:new, :create], module: :settings
  resources :charge_invoices, only: [:index, :edit, :update]
  resources :cash_on_hand_accounts, only: [:new, :create], module: :accounting

  namespace :store_front_module do
    resources :stock_transfer_registries, only: [:new, :create, :show], module: :registries
    resources :received_stock_transfer_registries, only: [:new, :create, :show], module: :registries
    resources :purchase_order_registries, only: [:new, :create, :show, :destroy], module: :registries do
      resources :purchase_order_line_items, only: [:destroy]
    end
    resources :customers, only: [:show] do
      resources :credit_sales_order_line_item_processings, only: [:new, :create, :destroy]
      resources :credit_sales_order_processings, only: [:create], module: :order_processings
    end
    resources :credit_sales_orders, only: [:show] do
      resources :payments, only: [:new, :create], module: :credit_sales_orders
    end
    resources :line_items, only: [:show]
    resources :spoilages, only: [:index, :show], module: :orders
    resources :spoilage_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :spoilage_order_processings, only: [:create], module: :orders
    resources :purchase_order_line_item_registries, only: [:create]
    resources :unit_of_measurements, only: [:edit, :update], module: :settings
    resources :selling_prices, only: [:new, :create], module: :settings
    resources :stock_transfers, only: [:index, :show, :edit, :update, :destroy], module: :orders
    resources :received_stock_transfers, only: [:index, :show], module: :orders
    resources :repair_services_orders, only: [:index, :show], module: :orders
    resources :sales_returns, only: [:index, :show], module: :orders
    resources :stock_transfer_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :received_stock_transfer_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :sales_return_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :product_mergings, only: [:new, :create], module: :settings
    resources :purchase_orders, only: [:new, :index, :show], module: :orders
    resources :internal_use_orders, only: [:index, :show], module: :orders
    resources :purchase_returns, only: [:index, :show], module: :orders
    resources :sales_orders, only: [:index, :show, :destroy], module: :orders do
      resources :additional_line_items, only: [:new, :create, :destroy], module: :sales_orders
      resources :additional_line_item_processings, only: [:create], module: :sales_orders
    end
    resources :purchase_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :purchase_return_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :sales_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :internal_use_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :purchase_order_processings, only: [:create], module: :orders
    resources :purchase_return_order_processings, only: [:create], module: :orders
    resources :sales_order_processings, only: [:create], module: :orders
    resources :stock_transfer_order_processings, only: [:create], module: :orders
    resources :received_stock_transfer_order_processings, only: [:create], module: :orders
    resources :sales_return_order_processings, only: [:create], module: :orders
    resources :internal_use_order_processings, only: [:create], module: :orders
  end

  resources :voucher_amounts, only: [:destroy]
  resources :vouchers, only: [:index, :show] do
    resources :disbursements, only: [:new, :create], module: :vouchers
  end
  namespace :repair_services_module do
      resources :repair_service_order_line_item_processings, only: [:destroy]
    resources :work_orders, only: [:show] do
      resources :service_charge_processings, only: [:new, :create]
      resources :payment_processings, only: [:new, :create, :show]
      resources :repair_service_order_line_item_processings, only: [:new, :create]
      resources :repair_service_order_processings, only: [:new, :create]
    end
    resources :service_payments, only: [:index, :show]
  end
  namespace :settings do
    resources :store_fronts, only: [:new, :create, :edit, :update]
  end

  resources :income_statement, only: [:index]
  namespace :accounting do
    resources :employees, only: [:show] do
      resources :cash_transfers, only: [:new, :create]
    end
    resources :bank_accounts, only: [:new, :create, :show] do
      resources :deposits, only: [:new, :create], module: :bank_accounts
      resources :withdrawals, only: [:new, :create], module: :bank_accounts
    end
    resources :finances, only: [:index]
    resources :entries, only: [:index, :show]
    resources :accounts, only: [:index, :show, :new, :create, :edit, :update] do
    match "/deactivate" => "accounts#deactivate",  via: [:post], on: :member

    end
  end
  resources :inventories, only: [:index, :show]
  resources :dashboard, only: [:index]
  namespace :admin do
    resources :employees, only: [:show] do
      resources :reports, only: [:index], module: :employees
      resources :sales, only: [:index], module: :employees
      resources :entries, only: [:index], module: :employees
    end
  end
  resources :work_order_service_charges, only: [:destroy]
  resources :credit_payments, only: [:index, :show]
  resources :employees, only: [:index, :show]
end
