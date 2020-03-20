# frozen_string_literal: true

class Offer
  include ActiveModel::Model

  attr_accessor :id,
                :seller_num_ratings,
                :seller_percent_positive,
                :seller_first_party,
                :seller_name,
                :seller_id,
                :marketplace_fulfilled,
                :international,
                :offer_id,
                :available,
                :handling_days_max,
                :handling_days_min,
                :price,
                :prime_only,
                :condition,
                :addon,
                :shipping_options,
                :product

  def weight
    product.weight
  end

  def quantity
    1
  end
end
