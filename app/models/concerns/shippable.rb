# frozen_string_literal: true

module Shippable
  include ActiveSupport::Concern

  def cost
    price
  end

  def insurance
    Insurance.new(price).cost
  end

  def freight
    Freight.new(weight).cost
  end

  def duty
    Duty.new(cost, insurance, freight).total_duty_payable
  end

  def handling
    Handling.new(price).cost
  end

  def freight_insurance_handling
    freight + insurance + handling
  end

  def total_cost
    cost + freight_insurance_handling + duty
  end
end
