# frozen_string_literal: true

class CartItem < ApplicationRecord
  include Shippable

  has_paper_trail

  belongs_to :cart, inverse_of: :cart_items

  def product_id
    Product.merge_retailer_with_product_id(self[:retailer], self[:product_id])
  end

  def price
    unit_price
  end
end
