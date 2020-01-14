# frozen_string_literal: true

class Order < ApplicationRecord
  has_paper_trail

  include ActionView::Helpers::NumberHelper

  belongs_to :cart
  belongs_to :user, inverse_of: :orders
  belongs_to :product, inverse_of: :orders

  enum delivery_method: { by_air: 0 }
  enum region: {
    greater_accra_region: 0,
    ashanti_region: 1,
    brong_ahafo_region: 2,
    central_region: 3,
    eastern_region: 4,
    northern_region: 5,
    upper_east_region: 6,
    upper_west_region: 7,
    volta_region: 8,
    western_region: 9
  }

  enum status: { pending: 0, failure: 1, success: 3 }

  delegate :number_of_items,
           :subtotal,
           :shipping_and_handling,
           :duty,
           :order_total, to: :cart

  def estimated_delivery_date
    2.weeks.from_now.to_date
  end
end
