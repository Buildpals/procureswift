# frozen_string_literal: true

class ItemInformationFetcher
  require 'net/http'
  require 'uri'

  OUNCE_TO_POUND_RATIO = 0.0625
  CENTS_TO_DOLLARS_RATIO = 0.01
  include ActionView::Helpers::NumberHelper

  def initialize(retailer, product_id)
    @retailer = retailer
    @product_id = product_id
  end

  def fetch_item_information
    return false if @product_id == false

    fetch_product_details
    fetch_product_offers
    build_product
  rescue Net::OpenTimeout, SocketError
    Rails.logger.warn 'Network error while fetching product information!'
    false
  end

  def zinc_product_details_url
    "https://api.zinc.io/v1/products/#{@product_id}?retailer=#{@retailer}"
  end

  def zinc_product_offers_url
    "https://api.zinc.io/v1/products/#{@product_id}/offers?retailer=#{@retailer}"
  end

  def title
    @zinc_product_details['title']
  end

  def main_image
    @zinc_product_details['main_image']
  end

  def product_details
    return nil if @zinc_product_details['product_details'].nil?

    @zinc_product_details['product_details'].first
  end

  def offers
    return [] if @zinc_product_offers.nil?

    @zinc_product_offers['offers']
  end

  def weight
    return nil if @zinc_product_details['package_dimensions'].nil?
    return nil if @zinc_product_details['package_dimensions']['weight'].nil?
    if @zinc_product_details['package_dimensions']['weight']['amount'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['weight']['unit'].nil?
      return nil
    end

    weight = @zinc_product_details['package_dimensions']['weight']['amount']
    weight_unit = @zinc_product_details['package_dimensions']['weight']['unit']
    case weight_unit
    when 'pounds'
      return weight
    when 'ounces'
      return weight * OUNCE_TO_POUND_RATIO
    else # TODO: Check for kilograms and grams and convert as necessary
      return weight
    end
  end

  def hs_code
    nil
  end

  def depth
    return nil if @zinc_product_details['package_dimensions']['size'].nil?
    if @zinc_product_details['package_dimensions']['size']['depth'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['depth']['amount'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['depth']['unit'].nil?
      return nil
    end

    unit = @zinc_product_details['package_dimensions']['size']['depth']['unit']

    # TODO: convert to inches based on unit
    @zinc_product_details['package_dimensions']['size']['depth']['amount']
  end

  def length
    return nil if @zinc_product_details['package_dimensions']['size'].nil?
    if @zinc_product_details['package_dimensions']['size']['length'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['length']['amount'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['length']['unit'].nil?
      return nil
    end

    unit = @zinc_product_details['package_dimensions']['size']['length']['unit']

    # TODO: convert to inches based on unit
    @zinc_product_details['package_dimensions']['size']['length']['amount']
  end

  def width
    return nil if @zinc_product_details['package_dimensions']['size'].nil?
    if @zinc_product_details['package_dimensions']['size']['width'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['width']['amount'].nil?
      return nil
    end
    if @zinc_product_details['package_dimensions']['size']['width']['unit'].nil?
      return nil
    end

    unit = @zinc_product_details['package_dimensions']['size']['width']['unit']

    # TODO: convert to inches based on unit
    @zinc_product_details['package_dimensions']['size']['width']['amount']
  end

  private

  def build_product
    product = Product.new
    product.product_id = @product_id
    product.retailer = @retailer
    product.title = title
    product.main_image = main_image
    product.offers = offers.map do |offer_result|
      Offer.new(
        id: offer_result['offer_id'],
        seller_num_ratings: offer_result['seller']['num_ratings'],
        seller_percent_positive: offer_result['seller']['percent_positive'],
        seller_first_party: offer_result['seller']['first_party'],
        seller_name: offer_result['seller']['name'],
        seller_id: offer_result['seller']['id'],
        marketplace_fulfilled: offer_result['marketplace_fulfilled'],
        international: offer_result['international'],
        available: offer_result['available'],
        handling_days_max: offer_result['handling_days']['max'],
        handling_days_min: offer_result['handling_days']['min'],
        price: offer_result['price'] * CENTS_TO_DOLLARS_RATIO,
        prime_only: offer_result['prime_only'],
        condition: offer_result['condition'],
        addon: offer_result['addon'],
        shipping_options: offer_result['shipping_options'],
        product: product
      )
    end
    product.weight = weight
    product.width = width
    product.length = length
    product.depth = depth
    product
  end

  def fetch_product_details
    uri = URI.parse(zinc_product_details_url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(
      Rails.application.credentials.config[:zincapi][:client_token], ''
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    Rails.logger.info "Fetching product details via #{uri}..."
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response_json = ActiveSupport::JSON.decode(response.body)
    Rails.logger.info "Product details fetched successfully for #{@retailer}_#{@product_id}!"
    Rails.logger.info response_json

    @zinc_product_details = response_json
  end

  def fetch_product_offers
    uri = URI.parse(zinc_product_offers_url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(
      Rails.application.credentials.config[:zincapi][:client_token],
      ''
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    Rails.logger.info "Fetching product offers via #{uri}..."
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response_json = ActiveSupport::JSON.decode(response.body)

    return if response_json['offers'].nil?
    return if response_json['offers'].empty?

    Rails.logger.info "Product offers fetched successfully for #{@retailer}_#{@product_id}!"
    Rails.logger.info response_json

    @zinc_product_offers = response_json
  end
end
