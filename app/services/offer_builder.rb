# frozen_string_literal: true

class OfferBuilder
  def initialize(product_offer, product)
    @product_offer = product_offer
    @product = product
  end

  def build
    Offer.new(
      id: @product_offer['offer_id'],
      seller_num_ratings: @product_offer['seller']['num_ratings'],
      seller_percent_positive: @product_offer['seller']['percent_positive'],
      seller_first_party: @product_offer['seller']['first_party'],
      seller_name: @product_offer['seller']['name'],
      seller_id: @product_offer['seller']['id'],
      marketplace_fulfilled: @product_offer['marketplace_fulfilled'],
      international: @product_offer['international'],
      available: @product_offer['available'],
      handling_days_max: @product_offer['handling_days']['max'],
      handling_days_min: @product_offer['handling_days']['min'],
      price: @product_offer['price'] * ProductBuilder::CENTS_TO_DOLLARS_RATIO,
      prime_only: @product_offer['prime_only'],
      condition: @product_offer['condition'],
      addon: @product_offer['addon'],
      shipping_options: @product_offer['shipping_options'],
      product: @product
    )
  end
end
