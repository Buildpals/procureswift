# frozen_string_literal: true

class AddUnitPriceToCartItems < ActiveRecord::Migration[6.0]
  def change
    add_column :cart_items, :unit_price, :decimal, precision: 8, scale: 2
  end
end
