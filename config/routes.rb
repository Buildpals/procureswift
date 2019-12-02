# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :products do
    resources :orders
  end

  resources :orders

  get 'admin/orders/', to: 'orders#admin_index', as: :admin_orders

  post 'products/payment_status', to: 'products#payment_status', as: :payment_status

  get '/payment', to: 'products#payment'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
