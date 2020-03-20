# frozen_string_literal: true

class CartItem < ApplicationRecord
  has_paper_trail

  belongs_to :cart, inverse_of: :cart_items

  def product_id
    Product.merge_retailer_with_product_id(self[:retailer], self[:product_id])
  end

  def cost
    unit_price
  end
end
