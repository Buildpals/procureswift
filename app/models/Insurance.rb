# frozen_string_literal: true

class Insurance
  INSURANCE_RATE = 0.10

  def initialize(price)
    raise ArgumentError, 'price is nil' if price.nil?

    @price = price
  end

  def cost
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
