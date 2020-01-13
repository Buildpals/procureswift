# frozen_string_literal: true

module ApplicationHelper
  DOLLAR_TO_CEDI_RATIO = 5.8

  def dollar_to_cedi(dollar_amount)
    dollar_amount * DOLLAR_TO_CEDI_RATIO
  end

  def number_to_currency_gh(amount)
    number_to_currency(amount, unit: 'GH₵ ')
  end
end
