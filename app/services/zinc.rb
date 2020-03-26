# frozen_string_literal: true

# Class for interacting with Zinc API
class Zinc
  require 'net/http'
  require 'uri'
  require "json"

  NETWORK_ERROR = 'Network error while fetching product information!'

  def product_search(query, retailer = 'amazon')
    raise ZincArgumentError, 'query is nil' if query.nil?
    raise ZincArgumentError, 'retailer is nil' if retailer.nil?

    product_search_url = "https://api.zinc.io/v1/search?query=#{query}" \
                         "&page=1&retailer=#{retailer}"
    product_search_json = make_api_call(product_search_url)

    build_products(product_search_json)
  end

  def product_details(retailer, product_id)
    raise ZincArgumentError, 'retailer is nil' if retailer.nil?
    raise ZincArgumentError, 'product_id is nil' if product_id.nil?

    product_details_url = "https://api.zinc.io/v1/products/#{product_id}" \
                         "?retailer=#{retailer}"
    product_details_json = make_api_call(product_details_url)

    build_product(product_details_json)
  end

  def product_offers(retailer, product_id)
    raise ZincArgumentError, 'retailer is nil' if retailer.nil?
    raise ZincArgumentError, 'product_id is nil' if product_id.nil?

    product_offers_url = "https://api.zinc.io/v1/products/#{product_id}" \
                         "/offers?retailer=#{retailer}"
    product_offers_json = make_api_call(product_offers_url)

    build_offers(product_offers_json)
  end

  def place_order(order_body)
    response = ''
    order_body.each do |v|
      response = make_order_call v unless v[:products].empty?
    end
    request_ids << response
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
  rescue Net::OpenTimeout, SocketError
    Rails.logger.error NETWORK_ERROR
    raise ZincError, NETWORK_ERROR
  end

  def make_order_call(body = Hash.new)
    url = URI("https://api.zinc.io/v1/orders")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = 'Basic NkY4NDRFM0JEQzc2Qzc5MTBEQTk3NDRGOg=='
    request.body = body.to_json
    response = https.request(request)
    response_json = ActiveSupport::JSON.decode(response.read_body)
    puts response_json
    if response_json['request_id'].nil?
      Rails.logger.error "Response for #{url}:\n#{response_json.to_json}"
      raise ZincError, response_json['message']
    else
      response_json['request_id']
    end
    # TO DO HANDLE ERRORS AND SUCCESS HERE
    # ON SUCCESS STORE REQUEST ID IN DATABASE
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

  class ZincArgumentError < StandardError
  end
end
