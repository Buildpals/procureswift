class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  def subtotal
    quantity * product.default_price
  end

  def shipping_and_handling
    quantity * product.shipping_and_handling
  end

  def duty
    quantity * product.duty
  end
end
