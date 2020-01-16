# frozen_string_literal: true

class CartItem < ApplicationRecord
  has_paper_trail

  belongs_to :cart
  belongs_to :product

  def subtotal
    quantity * product.default_price
  end

  def shipping_and_handling
    quantity * product.freight_insurance_handling
  end

  def duty
    quantity * product.duty
  end

  def total_cost
    subtotal + shipping_and_handling + duty
  end
end
