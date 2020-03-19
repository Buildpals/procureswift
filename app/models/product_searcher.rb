# frozen_string_literal: true

class ProductSearcher
  require 'net/http'
  require 'uri'

  def initialize(query, retailer = 'amazon')
    @query = query
    @retailer = retailer
  end

  def search
    response = make_api_call
    build_products(response)
  rescue Net::OpenTimeout, SocketError
    Rails.logger.warn 'Network error while fetching product information!'
    false
  end

  def zinc_product_search_url
    "https://api.zinc.io/v1/search?query=#{@query}&page=1&retailer=#{@retailer}"
  end

  private

  def build_products(response)
    response['results'].map do |result|
      Product.new(product_id: result['product_id'],
                  retailer: @retailer,
                  title: result['title'],
                  main_image: result['image'],

                  price: result['price'] ? result['price'] * ItemInformationFetcher::CENTS_TO_DOLLARS_RATIO : 'N/A',
                  stars: result['stars'],
                  num_reviews: result['num_reviews'])
    end
  end

  def make_api_call
    uri = URI.parse(zinc_product_search_url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(
      Rails.application.credentials.config[:zincapi][:client_token],
      ''
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    Rails.logger.info "Searching products #{uri}..."
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response_json = ActiveSupport::JSON.decode(response.body)
    Rails.logger.info "Product search for fetched successfully for #{@query}!"
    Rails.logger.info response_json

    response_json
  end
end
