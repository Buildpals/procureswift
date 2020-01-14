# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_one :order

  def add_product(cart_item_params)
    item = cart_items
           .find_by(product_id: cart_item_params[:product_id])
    if item
      item.quantity += 1
      item.save
    else
      item = cart_items
             .create(product_id: cart_item_params[:product_id],
                     quantity: 1,
                     cart_id: id)
    end
    item
  end

  def number_of_items
    cart_items.calculate(:sum, :quantity)
  end

  def subtotal
    cart_items.reduce(0) do |sum, cart_item|
      sum + cart_item.subtotal
    end
  end

  def shipping_and_handling
    cart_items.reduce(0) do |sum, cart_item|
      sum + cart_item.shipping_and_handling
    end
  end

  def duty
    cart_items.reduce(0) do |sum, cart_item|
      sum + cart_item.duty
    end
  end

  def order_total
    subtotal + shipping_and_handling + duty
  end
end
