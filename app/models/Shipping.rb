# frozen_string_literal: true

class Shipping
  GIGLOGISTICS_FREIGHT_RATE = 4.49
  INSURANCE_RATE = 0.10

  def initialize(weight_in_pounds, price, quantity = 1)
    raise ArgumentError, 'weight_in_pounds is nil' if weight_in_pounds.nil?
    raise ArgumentError, 'price is nil' if price.nil?

    @weight_in_pounds = weight_in_pounds
    @price = price
    @quantity = quantity
  end

  def cost
    unit_shipping_cost = freight + insurance
    unit_shipping_cost * @quantity
  end

  def freight
    @weight_in_pounds * GIGLOGISTICS_FREIGHT_RATE
  end

  def insurance
    @price * INSURANCE_RATE
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
