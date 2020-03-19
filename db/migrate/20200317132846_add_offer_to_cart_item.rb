# frozen_string_literal: true

class AddOfferToCartItem < ActiveRecord::Migration[6.0]
  def change
    remove_column :cart_items, :product_id, :bigint

    add_column :cart_items, :weight, :decimal, precision: 8, scale: 2
    add_column :cart_items, :seller_num_ratings, :integer
    add_column :cart_items, :seller_percent_positive, :decimal
    add_column :cart_items, :seller_first_party, :boolean
    add_column :cart_items, :seller_name, :string
    add_column :cart_items, :seller_id, :string
    add_column :cart_items, :marketplace_fulfilled, :boolean
    add_column :cart_items, :international, :boolean
    add_column :cart_items, :offer_id, :string
    add_column :cart_items, :available, :boolean
    add_column :cart_items, :handling_days_max, :integer
    add_column :cart_items, :handling_days_min, :integer
    add_column :cart_items, :prime_only, :boolean
    add_column :cart_items, :condition, :string
    add_column :cart_items, :addon, :boolean
    add_column :cart_items, :shipping_options, :string

    add_column :cart_items, :product_id, :string
    add_column :cart_items, :retailer, :string

    add_column :cart_items, :title, :string
    add_column :cart_items, :main_image, :string
    add_column :cart_items, :width, :decimal, precision: 8, scale: 2
    add_column :cart_items, :length, :decimal, precision: 8, scale: 2
    add_column :cart_items, :depth, :decimal, precision: 8, scale: 2
  end
end
