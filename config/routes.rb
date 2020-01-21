# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :products
    resources :carts
    resources :orders
    resources :users
  end

  devise_for :users

  root 'welcome#index'

  resources :products
  resources :carts
  resources :cart_items
  resources :orders

  # static pages
  get '/privacy_policy', to: 'welcome#privacy_policy', as: :privacy_policy
  get '/terms', to: 'welcome#terms', as: :terms_and_conditions
  get '/refund_policy', to: 'welcome#refund_policy', as: :refund_policy

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
