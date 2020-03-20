# frozen_string_literal: true

class Cart < ApplicationRecord
  has_paper_trail

  belongs_to :user, inverse_of: :carts

  has_many :cart_items, inverse_of: :cart, dependent: :destroy
  has_one :order, inverse_of: :cart, dependent: :destroy

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

  def add_cart_item(cart_item_params)
    # TODO: Fetch unit_price, weight and dimensions via ZincAPI and
    # override them in cart_item_params in order to prevent hackers from
    # crafting cart_items with lower prices, weight or dimensions than
    # actually specified on Amazon

    item = cart_items.find_by(product_id: cart_item_params[:product_id],
                              retailer: cart_item_params[:retailer])

    cart_item_params[:quantity] = 1

    if item
      cart_item_params[:quantity] += 1
      item.update!(cart_item_params)
      return item
    end

    cart_items.create!(cart_item_params)
  end
end
