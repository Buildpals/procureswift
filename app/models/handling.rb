# frozen_string_literal: true

class Handling
  BUILDPALS_MARKUP_RATE = 0.01
  BUILDPALS_MARKUP_BASE = 10

  def initialize(price, quantity=1)
    raise ArgumentError, 'price is nil' if price.nil?

    @price = price
    @quantity = quantity
  end

  def cost
    (@price * BUILDPALS_MARKUP_RATE + BUILDPALS_MARKUP_BASE) * @quantity
  end

  def hash
    cost.hash
  end

  def eql?(other)
    to_s == other.to_s
  end

  def to_s
    value.to_s
  end
end
