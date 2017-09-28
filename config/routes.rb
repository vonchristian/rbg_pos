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
  resources :products, except: [:destroy] do 
    match "/out_of_stock" => "products#out_of_stock",  via: [:get], on: :collection
    match "/low_on_stock" => "products#low_on_stock",  via: [:get], on: :collection

  	resources :stocks, only: [:new, :create], module: :products
  end
  resources :line_items, only: [:new, :create, :edit, :update]
  resources :orders, only: [:index, :show, :new, :create, :destroy]
  resources :carts, only: [:destroy]
  resources :categories, only: [:new, :create]
  resources :reports, only: [:index]
  resources :customer_registrations, only: [:new, :create]
  namespace :reports do 
    resources :sales, only: [:index]
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
  resources :suppliers, only: [:index, :show] do 
    resources :payments, only: [:new, :create], module: :suppliers
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:edit, :update]
  resources :registries, only: [:create, :show, :destroy]
  resources :employees, only: [:index, :show, :edit, :update]
  resources :work_orders, only: [:index, :new, :create]
  resources :work_order_statuses, only: [:edit, :update]
  namespace :computer_repair_section do 
    resources :dashboard, only: [:index]

    resources :work_orders do 
      resources :service_charges, only: [:new, :create], module: :work_orders
      resources :additional_charges, only: [:new, :create], module: :work_orders
      resources :spare_parts, only: [:new, :create, :destroy]
      resources :service_claim_tags, only: [:show]
      resources :payments, module: :work_orders, only: [:new, :create]
    end
    resources :work_order_service_charges, only: [:destroy]
    resources :work_order_updates, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :knowledge_center, only: [:index]
  resources :product_units, shallow: true do 
    resources :accessories, only: [:new, :create]
  end
  resources :warranties, only: [:edit, :update]
end
