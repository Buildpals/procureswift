# frozen_string_literal: true

class Order < ApplicationRecord
  has_paper_trail

  include ActionView::Helpers::NumberHelper

  belongs_to :user, inverse_of: :orders
  belongs_to :cart, inverse_of: :order

  enum status: { paid: 0,
                 bought: 1,
                 received_at_warehouse: 3,
                 shipped_to_ghana: 4,
                 received_in_ghana: 5,
                 delivered_to_client: 6 }

  def purchase
    
  end
end
