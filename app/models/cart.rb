# frozen_string_literal: true

class Cart < ApplicationRecord
  require 'securerandom'

  belongs_to :user
  has_many :cart_items
  has_one :order

  enum delivery_method: { by_air: 0 }
  enum region: {
    greater_accra_region: 0,
    ashanti_region: 1,
    brong_ahafo_region: 2,
    central_region: 3,
    eastern_region: 4,
    northern_region: 5,
    upper_east_region: 6,
    upper_west_region: 7,
    volta_region: 8,
    western_region: 9
  }

  def tx_ref
    "#{id}_#{SecureRandom.uuid}"
  end

  def add_product(cart_item_params)
    product = Product.find(cart_item_params[:product_id])

    item = cart_items.find_by(product_id: product.id)
    if item
      item.update!(quantity: item.quantity += 1,
                   unit_price: product.default_price)
      return item
    end

    cart_items.create!(product: product,
                       quantity: 1,
                       unit_price: product.default_price)
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

  def estimated_delivery_date
    if purchased_at.present?
      purchased_at + 2.weeks
    else
      2.weeks.from_now
    end
  end
end