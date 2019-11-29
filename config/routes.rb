# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  resources :orders

  post 'orders/payment_status'

  get '/payment', to: 'orders#payment'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
