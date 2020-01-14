# frozen_string_literal: true

class Freight
  GIGLOGISTICS_FREIGHT_RATE = 4.49

  def initialize(weight_in_pounds)
    raise ArgumentError, 'weight_in_pounds is nil' if weight_in_pounds.nil?

    @weight_in_pounds = weight_in_pounds
  end

  def cost
    @weight_in_pounds * GIGLOGISTICS_FREIGHT_RATE
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
