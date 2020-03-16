# frozen_string_literal: true

class Product < ApplicationRecord
  has_paper_trail

  include Shippable

  has_many :cart_items, inverse_of: :product, dependent: :destroy

  validates :item_url, presence: true, url: true
  validates :title, presence: true
  validates :price, presence: true
  validates :weight, presence: true

  before_validation :fetch_product_information, on: [:create]
  before_validation :set_chosen_offer, on: [:create]
  before_validation :set_price_from_chosen_offer
  before_validation :ensure_main_image_has_value

  private

  def fetch_product_information
    logger.info('Fetching product information from zincapi...')
    @item_information = ItemInformationFetcher.new(self)
    return unless @item_information.fetch_item_information

    logger.info('Setting product fields from zinc_api response...')
    self.title = @item_information.title
    self.main_image = @item_information.main_image
    self.offers = @item_information.offers
    self.weight = @item_information.weight
    self.width = @item_information.width
    self.length = @item_information.length
    self.depth = @item_information.depth
    logger.info('Product fields set successfully from zinc_api response!')
  end

  def set_chosen_offer
    logger.info('Setting chosen offer...')
    return if offers.nil?
    return if offers.empty?

    self.chosen_offer_id = offers.first['offer_id']
    logger.info('Chosen offer set successfully!')
  end

  def set_price_from_chosen_offer
    logger.info('Setting price from chosen offer...')
    return if chosen_offer_id.nil?
    return if offers.nil?
    return if offers.empty?

    chosen_offer = offers.find { |offer| offer['offer_id'] == chosen_offer_id }
    return if chosen_offer.nil?

    self.price = chosen_offer['price']
    logger.info('Price set successfully from chosen offer!')
  end

  def ensure_main_image_has_value
    logger.info('Ensuring main image has a value...')
    return unless main_image.nil?

    self.main_image =
      ActionController::Base.helpers.image_path('no_product_image')
    logger.info('Main image set to placeholder "no_product_image!"')
  end
end
