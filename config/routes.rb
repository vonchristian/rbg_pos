Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' , registrations: "bplo_section/settings/users"}
  
	root to: 'store#index'
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
