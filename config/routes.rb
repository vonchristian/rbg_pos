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
    resources :payments, only: [:new, :create], module: :customers
  end
  resources :products do
    resources :unit_of_measurements, only: [:new, :create]
    match "/out_of_stock" => "products#out_of_stock",  via: [:get], on: :collection
    match "/low_on_stock" => "products#low_on_stock",  via: [:get], on: :collection

  	resources :stocks, only: [:index, :new, :create], module: :products
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
  resources :line_items, only: [:destroy] do
    resources :sales_returns, only: [:new, :create], module: :line_items
    resources :stock_transfer_sales_returns, only: [:new, :create], module: :line_items
  end

  resources :job_orders, only: [:index, :new, :create]
  resources :stocks, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resources :transfers, only: [:new, :create], module: :stocks
  end
  resources :sales_returns, only: [:index]
  resources :settings, only: [:index]
  resources :branches, only: [:new, :create]
  resources :businesses, only: [:edit, :update]
  resources :warranties, only: [:index] do
    resources :releases, only: [:create], module: :warranties
  end
  resources :supplier_registrations, only: [:new, :create]
  namespace :suppliers do
    resources :merge_accounts, only: [:new, :create]
  end
  resources :suppliers, only: [:index, :show] do
    resources :purchase_orders, only: [:index], module: :suppliers
    resources :account, only: [:index], module: :suppliers
    resources :voucher_amounts, only: [:new, :create], module: :suppliers
    resources :vouchers, only: [:index, :create], module: :suppliers
    resources :payments, only: [:new, :create], module: :suppliers
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:edit, :update]
  resources :registries, only: [:create, :show, :destroy]
  resources :employees, only: [:index, :show, :edit, :update] do
    resources :remittances, only: [:new, :create], module: :employees
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
      resources :charge_invoices, only: [:new, :create], module: :work_orders
    end
    resources :work_order_service_charges, only: [:destroy]
    resources :work_order_updates, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :knowledge_center, only: [:index]
  resources :product_units, shallow: true do
    resources :accessories, only: [:new, :create]
  end
  resources :warranties, only: [:edit, :update]
  resources :branches, only: [:index, :show] do
    resources :stock_transfers, only: [:new, :create], module: :branches
    resources :line_items, only: [:create], module: :branches
  end
  resources :stock_transfers, only: [:index, :show, :destroy]
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
    resources :unit_of_measurements, only: [:edit, :update], module: :settings
    resources :selling_prices, only: [:new, :create], module: :settings
    resources :stock_transfers, only: [:index, :show], module: :orders
    resources :repair_services_orders, only: [:index, :show], module: :orders
    resources :sales_returns, only: [:index, :show], module: :orders
    resources :stock_transfer_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :sales_return_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :product_mergings, only: [:new, :create], module: :settings
    resources :purchase_orders, only: [:new, :index, :show], module: :orders
    resources :internal_use_orders, only: [:index, :show], module: :orders
    resources :purchase_returns, only: [:index, :show], module: :orders
    resources :sales_orders, only: [:index, :show], module: :orders
    resources :purchase_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :purchase_return_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :sales_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :internal_use_order_line_item_processings, only: [:new, :create, :destroy], module: :line_items
    resources :purchase_order_processings, only: [:create], module: :orders
    resources :purchase_return_order_processings, only: [:create], module: :orders
    resources :sales_order_processings, only: [:create], module: :orders
    resources :stock_transfer_order_processings, only: [:create], module: :orders
    resources :sales_return_order_processings, only: [:create], module: :orders
    resources :internal_use_order_processings, only: [:create], module: :orders

  end
  resources :voucher_amounts, only: [:destroy]
  resources :vouchers, only: [:index, :show] do
    resources :disbursements, only: [:new, :create], module: :vouchers
  end
  namespace :repair_services_module do
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
    resources :accounts, only: [:index, :show, :new, :create] do
    match "/deactivate" => "accounts#deactivate",  via: [:post], on: :member

    end
  end

end
