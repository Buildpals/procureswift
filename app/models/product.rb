# frozen_string_literal: true

class Product < ApplicationRecord
  has_paper_trail

  include ActionView::Helpers::NumberHelper

  require 'net/http'
  require 'uri'

  ZINC_API_KEY = '6F844E3BDC76C7910DA9744F'

  CENTS_TO_DOLLARS_RATIO = 0.01
  DUTY_RATIO = 0.07
  COST_PER_INCHES_CUBED = 0.0283
  INSURANCE_RATE = 0.03
  BASE_HANDLING_FEE = 5.00
  HANDLING_FEE_RATE = 0.01

  enum delivery_method: { by_air: 0, by_sea: 1 }
  enum delivery_region: {
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

  validate :is_valid_amazon_url

  def price_dollars
    return nil if zinc_product_offers.nil?
    return nil if zinc_product_offers['offers'].nil?
    return nil if chosen_offer_id.nil?

    chosen_offer = zinc_product_offers['offers'].find do |offer|
      offer['offer_id'] == chosen_offer_id
    end
    if chosen_offer
      chosen_offer['price'] * CENTS_TO_DOLLARS_RATIO
    else
      0.00
    end
  end

  def items_cost
    return nil if price_dollars.nil?

    price_dollars * item_quantity
  end

  def shipping_and_handling
    if by_sea?
      shipping_and_handling_by_sea
    else
      shipping_and_handling_by_air
    end
  end

  def shipping_and_handling_by_air
    return nil if items_cost.nil?

    item_shipping_cost = myus_shipping_cost

    return nil if item_shipping_cost.nil?

    insurance = items_cost * INSURANCE_RATE
    handling_fee = BASE_HANDLING_FEE + (items_cost * HANDLING_FEE_RATE)
    item_shipping_cost + insurance + handling_fee

    # TODO: Include region in delivery_Cost
  end

  def shipping_and_handling_by_sea
    return nil if items_cost.nil?
    return shipping_and_handling_by_air if volume.nil?

    item_shipping_cost = volume * COST_PER_INCHES_CUBED

    insurance = items_cost * INSURANCE_RATE
    handling_fee = BASE_HANDLING_FEE + (items_cost * HANDLING_FEE_RATE)
    item_shipping_cost + insurance + handling_fee

    # TODO: Include region in delivery_Cost
  end

  def myus_shipping_cost
    # TODO: Confirm these values by entering the ranges in https://www.myus.com/pricing/
    return nil if items_cost.nil?
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

  def estimated_delivery_date
    if by_sea?
      2.months.from_now.to_date
    else
      2.weeks.from_now.to_date
    end
  end

  def total_before_duty
    return nil if items_cost.nil?
    return nil if shipping_and_handling.nil?

    items_cost + shipping_and_handling
  end

  def estimated_duty
    return nil if items_cost.nil?

    items_cost * DUTY_RATIO
  end

  def product_total
    return nil if total_before_duty.nil?
    return nil if estimated_duty.nil?

    total_before_duty + estimated_duty
  end

  def title
    zinc_product_details['title']
  end

  def main_image
    zinc_product_details['main_image']
  end

  def offers
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

  def asin
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
  end

  private

  def is_valid_amazon_url
    asin_number = asin
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
    "https://api.zinc.io/v1/products/#{asin}?retailer=amazon"
  end

  def zinc_product_offers_url
    "https://api.zinc.io/v1/products/#{asin}/offers?retailer=amazon"
  end
end
