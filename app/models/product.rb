# frozen_string_literal: true

class Product < ApplicationRecord
  include Shippable

  has_paper_trail

  include ActionView::Helpers::NumberHelper

  CENTS_TO_DOLLARS_RATIO = 0.01

  validate :valid_amazon_url?

  delegate :weight,
           :weight_unit,
           :width,
           :width_unit,
           :length,
           :length_unit,
           :depth,
           :depth_unit,
           :volume,
           :weight_in_pounds, to: :dimensions

  def retailers_product_id
    Amazon.get_asin_from_url(item_url)
  end

  def title
    zinc_product_details['title']
  end

  def main_image
    zinc_product_details['main_image']
  end

  def product_details
    return nil if zinc_product_details['product_details'].nil?

    zinc_product_details['product_details'].first
  end

  def offers
    return [] if zinc_product_offers.nil?

    zinc_product_offers['offers'].map do |offer|
      [
        "#{number_to_currency(offer['price'] * CENTS_TO_DOLLARS_RATIO)} #{offer['condition']} #{offer['handling_days.max']} #{offer['seller.name']}",
        offer['offer_id']
      ]
    end
  end

  def default_price
    return nil if chosen_offer_id.nil?
    return nil if zinc_product_offers.nil?
    return nil if zinc_product_offers['offers'].nil?

    chosen_offer = zinc_product_offers['offers'].find do |offer|
      offer['offer_id'] == chosen_offer_id
    end

    return nil if chosen_offer.nil?

    chosen_offer['price'] * CENTS_TO_DOLLARS_RATIO
  end

  def dimensions
    @dimensions ||= Dimensions.new(zinc_product_details)
  end

  def save_product_details_to_file
    File.open("public/#{id}.json", 'w') do |f|
      f.write(zinc_product_details.to_json)
    end
    File.open("public/#{id}_offers.json", 'w') do |f|
      f.write(zinc_product_offers.to_json)
    end
  end

  private

  def valid_amazon_url?
    return unless retailers_product_id == false

    errors.add(:item_url, ': Please enter a valid Amazon link')
  end

  def add_custom_error(object = :base, error_message = 'Please provide a valid input')
    errors.add(object, error_message)
  end
end
