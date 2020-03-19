# frozen_string_literal: true

class Product
  include ActiveModel::Model

  RETAILERS = {
    amazon: 0,
    amazon_uk: 1,
    # amazon_ca: 2, # We don't have a warehouse in this country
    # amazon_de: 3, # We don't have a warehouse in this country
    # amazon_mx: 4, # We don't have a warehouse in this country
    costco: 5,
    walmart: 6,
    homedepot: 7,
    lowes: 8,
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

  def id
    "#{retailer}_#{product_id}"
  end

  def item_url
    "https://www.amazon.com/dp/#{id.split('_')[1]}"
  end

  def self.find(id)
    # TODO: HACK must be replaced with more rubost system
    retailer, product_id = id.split('_')

    Rails.logger.info('Fetching product information from zincapi...')
    product = ItemInformationFetcher.new(retailer, product_id).fetch_item_information
    product
  end

  def self.search(query, retailer = 'amazon')
    Zinc.new.search(query, retailer)
  end
end
