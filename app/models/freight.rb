# frozen_string_literal: true

# Calculates the freight cost of a product
class Freight
  def initialize(weight)
    @weight = weight
  end

  def cost
    myus_shipping_cost
  end

  def myus_shipping_cost
    return nil if @weight.nil?
    return 0 if @weight.zero?

    # TODO: Confirm these values by entering the ranges in https://www.myus.com/pricing/
    case @weight
    when 0..1
      16.99
    when 1..2
      28.99
    when 2..3
      40.99
    when 3..4
      50.99
    when 4..5
      57.99
    when 5..6
      63.99
    when 6..7
      64.99
    when 7..8
      65.99
    when 8..9
      73.99
    when 9..10
      74.99
    when 10..11
      94.99
    when 11..12
      95.99
    when 12..13
      100.99
    when 13..14
      107.99
    else
      5 * @weight + 59
    end
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
