# frozen_string_literal: true

# This does not inherit from ActiveRecord, but instead inherits from ActiveModel
class Product
  include ActiveModel::Model

  RETAILERS = {
    amazon: 0,
    amazon_uk: 1
  }.freeze

  RETAILER_PRODUCT_ID_SEPARATOR = '___'

  attr_accessor :product_id,
                :retailer,
                :title,
                :main_image,
                :price,
                :stars,
                :num_reviews,
                :weight,
                :width,
                :length,
                :depth,
                :offers

  def self.find(id)
    product_id, retailer = split_retailer_from_product_id(id)

    product = Zinc.new.product_details(retailer, product_id)
    offers = Zinc.new.product_offers(retailer, product_id)

    product.offers = offers
    offers.each { |offer| offer.product = product }

    product
  end

  def self.where(query, retailer = 'amazon')
    Zinc.new.product_search(query, retailer)
  end

  def self.split_retailer_from_product_id(id)
    retailer, product_id = id.split(RETAILER_PRODUCT_ID_SEPARATOR)
    [product_id, retailer]
  end

  def self.merge_retailer_with_product_id(retailer, product_id)
    "#{retailer}#{RETAILER_PRODUCT_ID_SEPARATOR}#{product_id}"
  end

  def id
    Product.merge_retailer_with_product_id(retailer, product_id)
  end

  def item_url
    product_id, retailer = Product.split_retailer_from_product_id(id)
    case retailer
    when :amazon.to_s
      "https://www.amazon.com/dp/#{product_id}"
    when :amazon_uk.to_s
      "https://www.amazon.co.uk/dp/#{product_id}"
    else
      raise ArgumentError, 'retailer is invalid!'
    end
  end
end
