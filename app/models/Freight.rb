# frozen_string_literal: true

class Freight
  GIGLOGISTICS_FREIGHT_RATE = 4.49

  def initialize(weight)
    @weight = weight
  end

  def cost
    @weight * GIGLOGISTICS_FREIGHT_RATE
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
