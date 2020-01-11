# frozen_string_literal: true

class Order < ApplicationRecord
  has_paper_trail

  include ActionView::Helpers::NumberHelper

  belongs_to :user, inverse_of: :orders
  belongs_to :product, inverse_of: :orders

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

  enum status: { pending: 0, failure: 1, success: 3 }

  def order_total
    return nil if items_cost.nil?
    return nil if shipping_and_handling.nil?

    items_cost + shipping_and_handling
  end

  def items_cost
    return nil if price.nil?

    price * quantity
  end

  def shipping_and_handling
    product.shipping_cost
  end

  def price
    return nil if product.zinc_product_offers.nil?
    return nil if product.zinc_product_offers['offers'].nil?
    return nil if product.chosen_offer_id.nil?

    chosen_offer = product.zinc_product_offers['offers'].find do |offer|
      offer['offer_id'] == chosen_offer_id
    end

    return nil if chosen_offer.nil?

    chosen_offer['price'] * Product::CENTS_TO_DOLLARS_RATIO
  end

  def estimated_delivery_date
    2.weeks.from_now.to_date
  end
end
