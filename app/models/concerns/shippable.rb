# frozen_string_literal: true

module Shippable
  include ActiveSupport::Concern

  def cost
    default_price
  end

  def insurance
    Insurance.new(default_price).cost
  end

  def freight
    Freight.new(dimensions.weight_in_pounds).cost
  end

  def duty
    Duty.new(cost, insurance, freight).total_duty_payable
  end

  def handling
    Handling.new(default_price).cost
  end

  def shipping_and_handling
    insurance + freight + handling
  end

  def total_cost
    cost + shipping_and_handling + duty
  end
end
