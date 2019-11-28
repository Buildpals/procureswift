class Order < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  require 'net/http'
  require 'uri'


  SHIPPING_AND_HANDLING_RATIO = 0.1
  DUTY_RATIO = 0.1
  ZINC_API_KEY = Rails.application.credentials.config[:zincapi][:client_token] 6F844E3BDC76C7910DA9744F

  enum delivery_method: {by_air: 0, by_sea: 1}
  enum delivery_region: {greater_accra: 0, ashanti: 1, eastern: 2}
  enum status: {pending: 0, failure: 1, success: 3}


  def price_dollars
    chosen_offer = zinc_product_offers["offers"].find { |offer| offer["offer_id"] == chosen_offer_id }
    chosen_offer["price"] / 100
  end

  def items_cost
    price_dollars * item_quantity
  end


  def shipping_and_handling
    items_cost * SHIPPING_AND_HANDLING_RATIO
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

  def offers
    zinc_product_offers["offers"].map do |offer|
      [
          "#{number_to_currency(offer["price"] / 100)} #{offer["condition"]} #{offer["handling_days.max"]} #{offer["seller.name"]}",
          offer["offer_id"]
      ]
    end
  end

  def fetch_item_information
    return unless zinc_product_details.nil? || zinc_product_offers.nil?
    fetch_product_details
    fetch_product_offers
  end

  def fetch_product_details
    uri = URI.parse(zinc_product_details_url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(ZINC_API_KEY, '')

    req_options = {
        use_ssl: uri.scheme == 'https',
    }

    puts 'Fetching details via zinc api...'

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    puts "Saving details from zinc api so we don't have to fetch it next time..."

    response_json = ActiveSupport::JSON.decode(response.body)
    update(zinc_product_details: response_json)
  end


  def fetch_product_offers
    uri = URI.parse(zinc_product_offers_url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(ZINC_API_KEY, "")

    req_options = {
        use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response_json = ActiveSupport::JSON.decode(response.body)
    update(zinc_product_offers: response_json, chosen_offer_id: response_json["offers"][0]["offer_id"])
  end

  def zinc_product_details_url
    puts "ASIN", asin
    "https://api.zinc.io/v1/products/#{asin}?retailer=amazon"
  end

  def zinc_product_offers_url
    puts "ASIN", asin
    "https://api.zinc.io/v1/products/#{asin}/offers?retailer=amazon"
  end

  private

  def asin
    Amazon.get_asin_from_url(item_url)
  end
end
