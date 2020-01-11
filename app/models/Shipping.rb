# frozen_string_literal: true

class Shipping
  GIGLOGISTICS_FREIGHT_RATE = 4.49

  BUILDPALS_MARKUP_RATE = 0.01
  BUILDPALS_MARKUP_BASE = 10

  INSURANCE_RATE = 0.10

  DUTY_RATIO = 0.5

  def initialize(weight_in_pounds, price)
    raise ArgumentError, 'weight_in_pounds is nil' if weight_in_pounds.nil?
    raise ArgumentError, 'price is nil' if price.nil?

    @weight_in_pounds = weight_in_pounds
    @price = price
  end

  def cost(quantity = 1)
    unit_shipping_cost = freight + insurance + buildpals_markup
    unit_shipping_cost * quantity
  end

  def freight
    @weight_in_pounds * GIGLOGISTICS_FREIGHT_RATE
  end

  def insurance
    @price * INSURANCE_RATE
  end

  def buildpals_markup
    @price * BUILDPALS_MARKUP_RATE + BUILDPALS_MARKUP_BASE
  end

  def estimated_duty
    cif = @price + insurance + freight
    cif * DUTY_RATIO
  end

  def hash
    cost.hash
  end

  def eql?(other)
    to_s == other.to_s
  end

  def to_s
    cost.to_s
  end
end
