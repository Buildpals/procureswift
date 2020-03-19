# frozen_string_literal: true

# This does not inherit from ActiveRecord, but instead inherits from ActiveModel
class Product
  include ActiveModel::Model

  RETAILERS = {
    amazon: 0,
    # amazon_uk: 1, # Haven't implemented unit conversion for GBP, kg, centimetres, millimetres, etc
    # amazon_ca: 2, # We don't have a warehouse in this country
    # amazon_de: 3, # We don't have a warehouse in this country
    # amazon_mx: 4, # We don't have a warehouse in this country
    costco: 5,
    walmart: 6,
    homedepot: 7,
    lowes: 8
    # aliexpress: 9 # We don't have a warehouse in this country
  }.freeze

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
    # TODO: HACK must be replaced with more robust splitting system
    retailer, product_id = id.split('_')
    [product_id, retailer]
  end

  def id
    "#{retailer}_#{product_id}"
  end

  def item_url
    product_id, _retailer = Product.split_retailer_from_product_id(id)
    "https://www.amazon.com/dp/#{product_id}"
  end
end
