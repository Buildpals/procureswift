# frozen_string_literal: true

# Class for interacting with Zinc API
class Zinc
  require 'net/http'
  require 'uri'

  NETWORK_ERROR = 'Network error while fetching product information!'

  def product_search(query, retailer = 'amazon')
    raise ArgumentError, 'query is nil' if query.nil?
    raise ArgumentError, 'retailer is nil' if retailer.nil?

    product_search_url = "https://api.zinc.io/v1/search?query=#{query}" \
                         "&page=1&retailer=#{retailer}"
    product_search_json = make_api_call(product_search_url)

    build_products(product_search_json)
  rescue Net::OpenTimeout, SocketError
    Rails.logger.warn NETWORK_ERROR
    []
  end

  def product_details(retailer, product_id)
    raise ArgumentError, 'retailer is nil' if retailer.nil?
    raise ArgumentError, 'product_id is nil' if product_id.nil?

    product_details_url = "https://api.zinc.io/v1/products/#{product_id}" \
                         "?retailer=#{retailer}"
    product_details_json = make_api_call(product_details_url)

    build_product(product_details_json)
  rescue Net::OpenTimeout, SocketError
    Rails.logger.warn NETWORK_ERROR
    nil
  end

  def product_offers(retailer, product_id)
    raise ArgumentError, 'retailer is nil' if retailer.nil?
    raise ArgumentError, 'product_id is nil' if product_id.nil?

    product_offers_url = "https://api.zinc.io/v1/products/#{product_id}" \
                         "/offers?retailer=#{retailer}"
    product_offers_json = make_api_call(product_offers_url)

    build_offers(product_offers_json)
  rescue Net::OpenTimeout, SocketError
    Rails.logger.warn NETWORK_ERROR
    raise ActiveRecord::RecordNotFound
  end

  private

  def make_api_call(url)
    Rails.logger.info "Making api call to #{url}..."

    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(
      Rails.application.credentials.config[:zincapi][:client_token],
      ''
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response_json = ActiveSupport::JSON.decode(response.body)

    if response_json['status'] == 'failed'
      Rails.logger.error "Response for #{url}:\n#{response_json.to_json}"
      raise ZincError, response_json['message']
    end

    Rails.logger.info "Response for #{url}:\n#{response_json.to_json}"

    response_json
  end

  def build_products(products_search_json)
    products_search_json['results'].map do |product_details_json|
      product_details_json['retailer'] = products_search_json['retailer']
      product_details_json['main_image'] = product_details_json['image']
      build_product(product_details_json)
    end
  end

  def build_product(product_details_json)
    ProductBuilder.new(product_details_json, []).build
  end

  def build_offers(product_offers_json)
    product_offers_json['offers'].map do |product_offer_json|
      OfferBuilder.new(product_offer_json, nil).build
    end
  end

  class ZincError < StandardError
  end
end
