Rails.application.routes.draw do
	root to: 'dashboard#index'
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
