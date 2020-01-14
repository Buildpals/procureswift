# frozen_string_literal: true

class ItemInformationFetcher
  require 'net/http'
  require 'uri'

  ZINC_API_KEY = Rails.application.credentials.config[:zincapi][:client_token]

  def initialize(product)
    @product = product
  end

  def fetch_item_information
    fetch_product_details
    fetch_product_offers
  rescue Net::OpenTimeout, SocketError
    false
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
    @product.update!(zinc_product_details: response_json)
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

    return if response_json['offers'].nil?
    return if response_json['offers'].empty?

    @product.update!(zinc_product_offers: response_json,
                     chosen_offer_id: response_json['offers'].first['offer_id'])
  end

  def zinc_product_details_url
    "https://api.zinc.io/v1/products/#{@product.retailers_product_id}?retailer=amazon"
  end

  def zinc_product_offers_url
    "https://api.zinc.io/v1/products/#{@product.retailers_product_id}/offers?retailer=amazon"
  end
end
