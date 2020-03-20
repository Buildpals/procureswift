# frozen_string_literal: true

require 'rails_helper'
include ApplicationHelper
include ActionView::Helpers::NumberHelper

RSpec.feature 'Order Management', vcr: {allow_playback_repeats: true} do
  let!(:user) { FactoryBot.create(:user) }
  let!(:cart) { FactoryBot.build(:cart) }

  let!(:cart1) { FactoryBot.create(:cart, user: user) }
  let!(:cart2) { FactoryBot.create(:cart, user: user) }

  let!(:cart_item1) { FactoryBot.create(:cart_item, cart: cart1) }
  let!(:cart_item2) { FactoryBot.create(:cart_item, cart: cart1) }
  let!(:cart_item3) { FactoryBot.create(:cart_item, cart: cart2) }

  let!(:order1) { FactoryBot.create(:order, user: user, cart: cart1) }
  let!(:order2) { FactoryBot.create(:order, user: user, cart: cart2) }

  scenario 'should be able to fill in delivery details for my order' do
    login_as user

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07G4MNFS1')
    click_button 'Add to Cart'

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07P8MQHSH')
    click_button 'Add to Cart', wait: 5 * 60

    click_link 'Cart (2)'

    click_link 'Checkout'

    expect(page).to have_content 'Order Summary'
    expect(page).to have_content 'Items (2): $700.99'
    expect(page).to have_content 'Shipping & Insurance: $79.03'
    expect(page).to have_content 'Estimated Duty: $278.12'
    expect(page).to have_content 'Order Total: $1,058.14 (GH₵ 6,137.19)'
    expect(page).to have_content "Estimated delivery #{2.weeks.from_now.to_date.to_s(:long)}"
    expect(page).to have_content 'Duty charges are subject to changes by customs officers on arrival'

    expect(page).to have_content 'Delivery Address'
    fill_in :cart_full_name, with: cart.full_name
    fill_in :cart_address, with: cart.address
    fill_in :cart_city_or_town, with: cart.city_or_town
    select cart.region.titleize, from: :cart_region
    fill_in :cart_phone_number, with: cart.phone_number

    click_button 'Save and Continue'

    within '#address_info_card' do
      expect(page).to have_content 'Delivery Address'
      expect(page).to have_content cart.full_name
      expect(page).to have_content cart.address
      expect(page).to have_content "#{cart.city_or_town}, #{cart.region.titleize}"
      expect(page).to have_content "Tel: #{cart.phone_number}"
    end

    expect(page).to have_content 'Items in Your Cart'

    within '#cart_list' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell Phone (Unlocked) - Just Black'
      expect(page).to have_content '$422.99'
      expect(page).to have_content 'Qty: 1'
      expect(page).to have_content 'Sony Noise Cancelling Headphones WH1000XM3: Wireless Bluetooth Over the Ear Headphones with Mic and Alexa voice control - Industry Leading Active Noise Cancellation - Black'
      expect(page).to have_content '$278.00'
      expect(page).to have_content 'Qty: 1'
    end

    expect(page).to have_content 'Modify Cart'

    within '#costs_card' do
      expect(page).to have_content 'Order Summary'
      expect(page).to have_content 'Items (2): $700.99 Shipping & Insurance: $79.03 Estimated Duty: $278.12 Order Total: $1,058.14 (GH₵ 6,137.19)'
      expect(page).to have_content "Estimated delivery #{2.weeks.from_now.to_date.to_s(:long)}"
      expect(page).to have_content 'Duty charges are subject to changes by customs officers on arrival'
      expect(page).to have_content 'Make Payment (GH₵ 6,137.19)'
    end
  end

  scenario 'should be able to pay for my order' do
    skip 'Having trouble writing specs for the Flutterwave modal that pops up' \
         ' when the user clicks the Make Payment button'
    login_as user

    visit product_path 'amazon_B07G4MNFS1'
    click_button 'Add to Cart'

    visit product_path 'amazon_B07P8MQHSH'
    click_button 'Add to Cart', wait: 5 * 60

    click_link 'Checkout'

    expect(page).to have_content 'Order Summary'
    expect(page).to have_content 'Items (2): $700.99', normalize_ws: true
    expect(page).to have_content 'Shipping & Insurance: $79.03', normalize_ws: true
    expect(page).to have_content 'Estimated Duty: $278.12', normalize_ws: true
    expect(page).to have_content 'Order Total: $1,058.14 (GH₵ 6,137.19)', normalize_ws: true
    expect(page).to have_content "Estimated delivery #{2.weeks.from_now.to_date.to_s(:long)}"
    expect(page).to have_content 'Duty charges are subject to changes by customs officers on arrival'

    expect(page).to have_content 'Delivery Address'
    fill_in :cart_full_name, with: cart.full_name
    fill_in :cart_address, with: cart.address
    fill_in :cart_city_or_town, with: cart.city_or_town
    select cart.region.titleize, from: :cart_region
    fill_in :cart_phone_number, with: cart.phone_number

    click_button 'Save and Continue'

    within '#address_info_card' do
      expect(page).to have_content 'Delivery Address'
      expect(page).to have_content cart.full_name
      expect(page).to have_content cart.address
      expect(page).to have_content "#{cart.city_or_town}, #{cart.region.titleize}"
      expect(page).to have_content "Tel: #{cart.phone_number}"
    end

    expect(page).to have_content 'Items in Your Cart'

    within '#cart_list' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell Phone (Unlocked) - Just Black'
      expect(page).to have_content '$422.99'
      expect(page).to have_content 'Qty: 1'
      expect(page).to have_content 'Sony Noise Cancelling Headphones WH1000XM3: Wireless Bluetooth Over the Ear Headphones with Mic and Alexa voice control - Industry Leading Active Noise Cancellation - Black'
      expect(page).to have_content '$278.00'
      expect(page).to have_content 'Qty: 1'
    end

    expect(page).to have_content 'Modify Cart'

    within '#costs_card' do
      expect(page).to have_content 'Order Summary'
      expect(page).to have_content 'Items (2): $700.99', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $79.03', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $278.12', normalize_ws: true
      expect(page).to have_content 'Order Total: $1,058.14 (GH₵ 6,137.19)', normalize_ws: true
      expect(page).to have_content "Estimated delivery #{2.weeks.from_now.to_date.to_s(:long)}"
      expect(page).to have_content 'Duty charges are subject to changes by customs officers on arrival'
      expect(page).to have_content 'Make Payment (GH₵ 6,329.65)'
    end

    click_button 'Make Payment (GH₵ 6,329.65)'

    # TODO: The expectation below fails, preventing us from implementing tests for FlutterWave
    expect(page).to have_content 'SECURED BY FLUTTERWAVE', wait: 1 * 60
  end

  scenario 'should be able to view a list of all my orders' do
    login_as user

    visit orders_path

    expect(page).to have_content 'Your Orders'

    expect(page).to have_content "Order Placed: #{order2.cart&.paid_at&.to_date&.to_s(:long)}"
    expect(page).to have_content "Total: #{number_to_currency_gh dollar_to_cedi ShippingCalculator.new(order2.cart).order_total}"
    expect(page).to have_content "Ship To: #{order2.cart.full_name}"
    expect(page).to have_link 'Order Details', href: order_path(order2)

    expect(page).to have_content cart_item3.title
    expect(page).to have_content number_to_currency cart_item3.unit_price
    expect(page).to have_content cart_item3.quantity

    expect(page).to have_content "Order Placed: #{order1.cart&.paid_at&.to_date&.to_s(:long)}"
    expect(page).to have_content "Total: #{number_to_currency_gh dollar_to_cedi ShippingCalculator.new(order1.cart).order_total}"
    expect(page).to have_content "Ship To: #{order1.cart.full_name}"
    expect(page).to have_link 'Order Details', href: order_path(order1)

    expect(page).to have_content cart_item1.title
    expect(page).to have_content number_to_currency cart_item1.unit_price
    expect(page).to have_content cart_item1.quantity
    expect(page).to have_content cart_item2.title

    expect(page).to have_content number_to_currency cart_item2.unit_price
    expect(page).to have_content cart_item2.quantity
  end
end
