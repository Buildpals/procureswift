# frozen_string_literal: true

class Product < ApplicationRecord
  has_paper_trail

  include ActionView::Helpers::NumberHelper

  require 'net/http'
  require 'uri'

  ZINC_API_KEY = Rails.application.credentials.config[:zincapi][:client_token]

  CENTS_TO_DOLLARS_RATIO = 0.01
  DUTY_RATIO = 0.07
  COST_PER_INCHES_CUBED = 0.0283
  INSURANCE_RATE = 0.03
  BASE_HANDLING_FEE = 5.00
  HANDLING_FEE_RATE = 0.01

  has_many :orders, inverse_of: :product

  validate :is_valid_amazon_url

  def default_price
    return nil if zinc_product_offers.nil?
    return nil if zinc_product_offers['offers'].nil?
    return nil if chosen_offer_id.nil?

    chosen_offer = zinc_product_offers['offers'].find do |offer|
      offer['offer_id'] == chosen_offer_id
    end

    return nil if chosen_offer.nil?

    chosen_offer['price'] * CENTS_TO_DOLLARS_RATIO
  end

  def shipping_and_handling_by_air(price, quantity)
    return nil if price.nil?

    item_shipping_cost = myus_shipping_cost

    return nil if item_shipping_cost.nil?

    shipping_and_handling(item_shipping_cost, price, quantity)
  end

  def shipping_and_handling_by_sea(price, quantity)
    return nil if price.nil?
    return shipping_and_handling_by_air(price, quantity) if volume.nil?

    item_shipping_cost = volume * COST_PER_INCHES_CUBED

    shipping_and_handling(item_shipping_cost, price, quantity)
  end

  def myus_shipping_cost
    # TODO: Confirm these values by entering the ranges in https://www.myus.com/pricing/
    return nil if item_weight_in_pounds.nil?

    case item_weight_in_pounds
    when 0..1
      16.99
    when 1..2
      28.99
    when 2..3
      40.99
    when 3..4
      50.99
    when 4..5
      57.99
    when 5..6
      63.99
    when 6..7
      64.99
    when 7..8
      65.99
    when 8..9
      73.99
    when 9..10
      74.99
    when 10..11
      94.99
    when 11..12
      95.99
    when 12..13
      100.99
    when 13..14
      107.99
    else
      5 * item_weight_in_pounds + 59
    end
  end

  def title
    zinc_product_details['title']
  end

  def main_image
    zinc_product_details['main_image']
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

  def depth
    return nil if zinc_product_details['package_dimensions'].nil?
    return nil if zinc_product_details['package_dimensions']['size'].nil?
    if zinc_product_details['package_dimensions']['size']['depth'].nil?
      return nil
    end
    if zinc_product_details['package_dimensions']['size']['depth']['amount'].nil?
      return nil
    end

    zinc_product_details['package_dimensions']['size']['depth']['amount']
  end

  def depth_unit
    return nil if zinc_product_details['package_dimensions'].nil?
    return nil if zinc_product_details['package_dimensions']['size'].nil?
    if zinc_product_details['package_dimensions']['size']['depth'].nil?
      return nil
    end
    if zinc_product_details['package_dimensions']['size']['depth']['unit'].nil?
      return nil
    end

    zinc_product_details['package_dimensions']['size']['depth']['unit']
  end

  def length
    return nil if zinc_product_details['package_dimensions'].nil?
    return nil if zinc_product_details['package_dimensions']['size'].nil?
    if zinc_product_details['package_dimensions']['size']['length'].nil?
      return nil
    end
    if zinc_product_details['package_dimensions']['size']['length']['amount'].nil?
      return nil
    end

    zinc_product_details['package_dimensions']['size']['length']['amount']
  end

  def length_unit
    return nil if zinc_product_details['package_dimensions'].nil?
    return nil if zinc_product_details['package_dimensions']['size'].nil?
    if zinc_product_details['package_dimensions']['size']['length'].nil?
      return nil
    end
    if zinc_product_details['package_dimensions']['size']['length']['unit'].nil?
      return nil
    end

    zinc_product_details['package_dimensions']['size']['length']['unit']
  end

  def width
    return nil if zinc_product_details['package_dimensions'].nil?
    return nil if zinc_product_details['package_dimensions']['size'].nil?
    if zinc_product_details['package_dimensions']['size']['width'].nil?
      return nil
    end
    if zinc_product_details['package_dimensions']['size']['width']['amount'].nil?
      return nil
    end

    zinc_product_details['package_dimensions']['size']['width']['amount']
  end

  def width_unit
    return nil if zinc_product_details['package_dimensions'].nil?
    return nil if zinc_product_details['package_dimensions']['size'].nil?
    if zinc_product_details['package_dimensions']['size']['width'].nil?
      return nil
    end
    if zinc_product_details['package_dimensions']['size']['width']['unit'].nil?
      return nil
    end

    zinc_product_details['package_dimensions']['size']['width']['unit']
  end

  def volume
    return nil if width.nil?
    return nil if length.nil?
    return nil if depth.nil?

    width * length * depth
  end

  def weight
    return nil if zinc_product_details['package_dimensions'].nil?
    return nil if zinc_product_details['package_dimensions']['weight'].nil?
    if zinc_product_details['package_dimensions']['weight']['amount'].nil?
      return nil
    end

    zinc_product_details['package_dimensions']['weight']['amount']
  end

  def item_weight_in_pounds
    case weight_unit
    when 'pounds'
      weight
    when 'ounces'
      weight * 0.0625
    else
      weight
    end
  end

  def weight_unit
    return nil if zinc_product_details['package_dimensions'].nil?
    return nil if zinc_product_details['package_dimensions']['weight'].nil?
    if zinc_product_details['package_dimensions']['weight']['unit'].nil?
      return nil
    end

    zinc_product_details['package_dimensions']['weight']['unit']
  end

  def product_details
    return nil if zinc_product_details['product_details'].nil?

    zinc_product_details['product_details'].first
  end

  def retailers_product_id
    Amazon.get_asin_from_url(item_url)
  end

  def fetch_item_information
    return unless zinc_product_details.nil? || zinc_product_offers.nil?

    fetch_product_details
    fetch_product_offers
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

  def shipping_and_handling(item_shipping_cost, price, quantity)
    insurance = price * INSURANCE_RATE
    handling_fee = price * HANDLING_FEE_RATE + BASE_HANDLING_FEE
    unit_shipping_cost = item_shipping_cost + insurance + handling_fee + estimated_duty(price)
    unit_shipping_cost * quantity
  end

  def estimated_duty(price)
    return nil if price.nil?

    price * DUTY_RATIO
  end

  def is_valid_amazon_url
    asin_number = retailers_product_id
    if asin_number == false
      errors.add(:item_link, ': Please enter a valid amazon link')
    end
  end

  def fetch_product_details
    uri = URI.parse(zinc_product_details_url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(ZINC_API_KEY, '')

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    puts "Fetching product details via #{uri}..."

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    puts "Saving details from #{uri} so we don't have to fetch it next time..."

    response_json = ActiveSupport::JSON.decode(response.body)
    update(zinc_product_details: response_json)
  end

  def fetch_product_offers
    uri = URI.parse(zinc_product_offers_url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(ZINC_API_KEY, '')

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response_json = ActiveSupport::JSON.decode(response.body)
    update(zinc_product_offers: response_json,
           chosen_offer_id: response_json['offers'][0]['offer_id'])
  end

  def zinc_product_details_url
    "https://api.zinc.io/v1/products/#{retailers_product_id}?retailer=amazon"
  end

  def zinc_product_offers_url
    "https://api.zinc.io/v1/products/#{retailers_product_id}/offers?retailer=amazon"
  end
end
