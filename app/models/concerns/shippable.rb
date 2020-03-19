# frozen_string_literal: true

module Shippable
  include ActiveSupport::Concern

  def cost
    quantity * price
  end

  def insurance
    quantity * Insurance.new(price).cost
  end

  def freight
    total_weight = quantity * weight
    Freight.new(total_weight).cost
  end

  def duty
    Duty.new(cost, insurance, freight).total_duty_payable
  end

  def handling
    total_price = quantity * price
    Handling.new(total_price).cost
  end

  def freight_insurance_handling
    freight + insurance + handling
  end

  def total_cost
    cost + freight_insurance_handling + duty
  end
end
