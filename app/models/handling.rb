# frozen_string_literal: true

class Handling
  BUILDPALS_MARKUP_BASE = 10
  BUILDPALS_MARKUP_RATE = 0.01

  def initialize(price)
    raise ArgumentError, 'price is nil' if price.nil?

    @price = price
  end

  def cost
    BUILDPALS_MARKUP_BASE + @price * BUILDPALS_MARKUP_RATE
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
