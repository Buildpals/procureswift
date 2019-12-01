# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  resources :products

  get 'products/:id/checkout', to: 'products#checkout', as: :checkout

  post 'products/payment_status'

  get '/payment', to: 'products#payment'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
