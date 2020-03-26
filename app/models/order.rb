# frozen_string_literal: true

# Create two columns api status and api hash
# Use those two columns to query the status of the order

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
                 delivered_to_client: 6,
                 pending: 7,
                 aborted: 8,
                 account_locked_verification_required: 9 }

  def purchase; end
end
