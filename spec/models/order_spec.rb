require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  let!(:user) { FactoryBot.create(:user) }

  let!(:cart) { FactoryBot.create(:cart, user: user) }

  let!(:cart_item1) { FactoryBot.create(:cart_item, cart: cart )}
  let!(:cart_item2) { FactoryBot.create(:cart_item, cart: cart )}

  let!(:order) { FactoryBot.create(:order, user: user, cart: cart) }

  let!(:ship) {ShippingCalculator.new(order.cart)}

  context 'shipping calculator tests' do
    it 'ensures delivery date is correctly estimated' do 
      estimate_date = order.cart.paid_at + 2.weeks
      expect(ship.estimated_delivery_date).to eq(estimate_date)
    end

    it 'ensures total quantity is correct' do
      quantity = cart_item1.quantity + cart_item2.quantity
      expect(ship.number_of_items).to eq(quantity)
    end

    it 'ensures cost of item is correct' do
      expect(ship.cost).to eq(total_cost)
    end

    it 'ensures weight is correct' do
      weight = (cart_item1.weight * cart_item1.quantity) + (cart_item2.weight * cart_item2.quantity)
      expect(ship.weight).to eq(weight)
    end

    it 'ensures insurance is correct' do
      expect(ship.insurance).to eq(total_cost * Insurance::INSURANCE_RATE)
    end

    it 'ensures handling is correct' do
      expect(ship.handling).to eq(Handling::BUILDPALS_MARKUP_BASE + total_cost * Handling::BUILDPALS_MARKUP_RATE)
    end

    it 'ensures freight is correct' do
      # TO DO
    end

    it 'ensures duty is correct' do
      # TO DO
    end

    def total_cost
      (cart_item1.cost * cart_item1.quantity) + (cart_item2.cost * cart_item2.quantity)
    end

  end
end
