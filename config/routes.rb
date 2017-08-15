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
	resources :store, only: [:index]
	resources :customers
  resources :products, except: [:destroy] do 
  	resources :stocks, only: [:new, :create]
  end
  resources :line_items, only: [:new, :create]
  resources :orders, only: [:index, :show, :new, :create]
  resources :carts, only: [:destroy]
  resources :categories, only: [:new, :create]
  resources :reports, only: [:index]
  resources :customer_registrations, only: [:new, :create]
  namespace :reports do 
    resources :sales, only: [:index]
  end
  resources :accounting, only: [:index]
  namespace :accounting do 
    resources :entries, only: [:show]
  end
  resources :line_items, only: [:destroy] do 
    resources :sales_returns, only: [:new, :create], module: :line_items
  end

  resources :job_orders, only: [:index, :new, :create]
  resources :stocks, only: [:index, :show] do 
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
  resources :suppliers, only: [:index, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:edit, :update]
  resources :registries, only: [:create]
end
