# frozen_string_literal: true

class Order < ApplicationRecord
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

  SHIPPING_AND_HANDLING_RATIO = 0.25

  enum delivery_method: { by_air: 0, by_sea: 1 }
  enum delivery_region: {
    greater_accra_region: 0,
    ashanti_region: 1,
    central_region: 2,
    eastern_region: 3,
    oti_region: 4,
    bono_east_region: 5,
    ahafo_region: 6,
    bono_region: 7,
    north_east_region: 8,
    savanna_region: 9,
    western_region: 10 ,
    western_north_region: 11,
    volta_region: 12,
    northern_region: 13,
    upper_east_region: 14,
    upper_west_region: 15
  }

  enum status: { pending: 0, failure: 1, success: 3 }

  def price_dollars
    chosen_offer = zinc_product_offers['offers'].find do |offer|
      offer['offer_id'] == chosen_offer_id
    end
    chosen_offer['price'] * CENTS_TO_DOLLARS_RATIO
  end

  def items_cost
    price_dollars * item_quantity
  end

  def shipping_and_handling
    if by_sea? && width.present? && length.present? && depth.present?
      item_shipping_cost = volume * COST_PER_INCHES_CUBED
    else
      item_shipping_cost = myus_shipping_cost
    end

    insurance = items_cost * INSURANCE_RATE
    handling_fee = BASE_HANDLING_FEE + (items_cost * HANDLING_FEE_RATE)
    item_shipping_cost + insurance + handling_fee
    # TODO: Include region in delivery_Cost
  end

  def estimated_delivery_date
    if by_sea?
      '31st January, 2018'
    else
      '9th December, 2018'
    end
  end

  def myus_shipping_cost
    # TODO: Confirm these values by entering the ranges in https://www.myus.com/pricing/
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
    else
      items_cost * SHIPPING_AND_HANDLING_RATIO
    end
  end

  def total_before_duty
    items_cost + shipping_and_handling
  end

  def estimated_duty
    items_cost * DUTY_RATIO
  end

  def order_total
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
    # TODO: Convert to inches
    if zinc_product_details['package_dimensions']
      if zinc_product_details['package_dimensions']['size']
        if zinc_product_details['package_dimensions']['size']['depth']
          zinc_product_details['package_dimensions']['size']['depth']['amount']
        end
      end
    end

    nil
  end

  def depth_unit
    zinc_product_details['package_dimensions']['size']['depth']['unit']
  end

  def length
    # TODO: Convert to inches
    if zinc_product_details['package_dimensions']
      if zinc_product_details['package_dimensions']['size']
        if zinc_product_details['package_dimensions']['size']['length']
          zinc_product_details['package_dimensions']['size']['length']['amount']
        end
      end
    end

    nil
  end

  def length_unit
    zinc_product_details['package_dimensions']['size']['length']['unit']
  end

  def width
    # TODO: Convert to inches
    if zinc_product_details['package_dimensions']
      if zinc_product_details['package_dimensions']['size']
        if zinc_product_details['package_dimensions']['size']['width']
          zinc_product_details['package_dimensions']['size']['width']['amount']
        end
      end
    end

    nil
  end

  def width_unit
    zinc_product_details['package_dimensions']['size']['width']['unit']
  end

  def volume
    width * length * depth
  end

  def weight
    if zinc_product_details['package_dimensions']
      if zinc_product_details['package_dimensions']['weight']
        zinc_product_details['package_dimensions']['weight']['amount']
      end
    end

    nil
  end

  def item_weight_in_pounds
    # TODO: Convert to pounds
    weight
  end

  def weight_unit
    zinc_product_details['package_dimensions']['weight']['unit']
  end

  def product_details
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

  private

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
