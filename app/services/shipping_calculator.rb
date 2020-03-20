# frozen_string_literal: true

# TODO: Kwaku, please write unit tests for this very important class so
# Procureswift does not lose money.
class ShippingCalculator
  def initialize(cart)
    @cart = cart
  end

  def estimated_delivery_date
    return @cart.paid_at + 2.weeks if @cart.paid_at.present?

    2.weeks.from_now
  end

  def number_of_items
    @cart.cart_items.reduce(0) do |total_quantity, cart_item|
      total_quantity + cart_item.quantity
    end
  end

  def order_total
    cost + freight_insurance_handling + duty
  end

  def cost
    @cart.cart_items.reduce(0) do |total_cost, cart_item|
      total_cost + (cart_item.cost * cart_item.quantity)
    end
  end

  def freight_insurance_handling
    freight + insurance + handling
  end

  def freight
    Freight.new(weight).cost
  end

  def weight
    @cart.cart_items.reduce(0) do |total_weight, cart_item|
      total_weight + (cart_item.weight * cart_item.quantity)
    end
  end

  def insurance
    Insurance.new(cost).cost
  end

  def handling
    Handling.new(cost).cost
  end

  def duty
    Duty.new(cost, insurance, freight).total_duty_payable
  end
end
