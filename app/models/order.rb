# frozen_string_literal: true

class Order < ApplicationRecord
  has_paper_trail

  include ActionView::Helpers::NumberHelper

  belongs_to :user, inverse_of: :orders
  belongs_to :cart, inverse_of: :order

  enum status: { pending: 0, failure: 1, success: 3 }

  delegate :number_of_items,
           :subtotal,
           :shipping_and_handling,
           :duty,
           :order_total, to: :cart
end
