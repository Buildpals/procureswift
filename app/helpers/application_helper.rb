# frozen_string_literal: true

module ApplicationHelper
  DOLLAR_TO_CEDI_RATIO = 5.8

  def dollar_to_cedi(dollar_amount)
    dollar_amount * DOLLAR_TO_CEDI_RATIO
  end

  def number_to_currency_gh(amount)
    number_to_currency(amount, unit: 'GH₵ ')
  end

  def offer_choices(offers)
    offers.map do |offer|
      [
        offer['offer_id'],
        "#{number_to_currency(offer['price'])} #{offer['condition']}"
      ]
    end
  end
end
