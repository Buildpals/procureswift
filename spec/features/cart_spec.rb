# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Cart Management', vcr: { allow_playback_repeats: true } do
  let(:cart) { FactoryBot.create(:cart) }
  let(:cart_item1) { FactoryBot.create(:cart_item, cart: cart, quantity: 1) }
  let(:cart_item2) { FactoryBot.create(:cart_item, cart: cart, quantity: 2) }
  let(:cart_item3) { FactoryBot.create(:cart_item, cart: cart, quantity: 3) }

  scenario 'should force user to sign in if he hasn\'t signed in before checkout' do
    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07G4MNFS1')
    click_link 'Add to Cart'
    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Full name'
    expect(page).to have_content 'Email'
    expect(page).to have_content 'Phone number'
    expect(page).to have_content 'Password (6 characters minimum)'
    expect(page).to have_content 'Password confirmation'
    expect(page).to have_content 'Already a user? Click here to Login'
  end

  scenario 'should be able to view my cart' do
    login_as cart.user

    visit root_path
    click_link 'Cart (0)'

    expect(page).to have_content 'Items in Your Cart'

    within '#costs_card' do
      expect(page).to have_content 'Order Summary'
      expect(page).to have_content 'Items (0): $0.00 ', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $0.00 ', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $0.00 ', normalize_ws: true
      expect(page).to have_content 'Order Total: $0.00 (GH₵ 0.00) ', normalize_ws: true
      expect(page).to have_content 2.weeks.from_now.to_date.to_s(:long), normalize_ws: true

      expect(page).to have_content 'Duty charges are subject to changes by ' \
                                   'customs officers on arrival Checkout',
                                   normalize_ws: true
    end
  end

  scenario 'should be able to add a product to the cart' do
    login_as cart.user

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07G4MNFS1')
    click_button 'Add to Cart'

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07P8MQHSH')
    click_button 'Add to Cart'

    click_link 'Cart (2)'

    expect(page).to have_content 'Items in Your Cart'

    within '#cart_list' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell ' \
                                   'Phone (Unlocked) - Just Black $422.99',
                                   normalize_ws: true

      expect(page).to have_content 'Sony Noise Cancelling Headphones ' \
                                   'WH1000XM3: Wireless Bluetooth Over the ' \
                                   'Ear Headphones with Mic and Alexa voice ' \
                                   'control - Industry Leading Active Noise ' \
                                   'Cancellation - Black $278.00',
                                   normalize_ws: true
    end

    within '#costs_card' do
      expect(page).to have_content 'Order Summary'
      expect(page).to have_content 'Items (2): $700.99 ', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $106.02 ', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $284.31 ', normalize_ws: true
      expect(page).to have_content 'Order Total: $1,091.32 (GH₵ 6,329.65) ', normalize_ws: true
      expect(page).to have_content 2.weeks.from_now.to_date.to_s(:long), normalize_ws: true

      expect(page).to have_content 'Duty charges are subject to changes by ' \
                                   'customs officers on arrival Checkout',
                                   normalize_ws: true
    end
  end

  scenario 'should be able to change the quantity of a product in my cart', js: true do
    login_as cart.user

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07G4MNFS1')
    click_button 'Add to Cart'

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07P8MQHSH')
    click_button 'Add to Cart'

    expect(page).to have_content 'Items in Your Cart'

    within '#cart_list' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell ' \
                                   'Phone (Unlocked) - Just Black $199.97 ',
                                   normalize_ws: true

      expect(page).to have_content 'Sony Noise Cancelling Headphones ' \
                                   'WH1000XM3: Wireless Bluetooth Over the ' \
                                   'Ear Headphones with Mic and Alexa voice ' \
                                   'control - Industry Leading Active Noise ' \
                                   'Cancellation - Black $278.00',
                                   normalize_ws: true
    end

    within '#costs_card' do
      expect(page).to have_content 'Order Summary'
      expect(page).to have_content 'Items (2): $477.97 ', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $97.10 ', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $200.58 ', normalize_ws: true
      expect(page).to have_content 'Order Total: $775.65 (GH₵ 4,498.77) ', normalize_ws: true
      expect(page).to have_content 2.weeks.from_now.to_date.to_s(:long), normalize_ws: true

      expect(page).to have_content 'Duty charges are subject to changes by ' \
                                   'customs officers on arrival Checkout',
                                   normalize_ws: true
    end

    within '#cart_list .list-group-item', match: :first do
      select '2', from: :cart_item_quantity
    end

    within '#costs_card' do
      expect(page).to have_content 'Items (3): $677.94', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $117.10', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $280.03', normalize_ws: true
      expect(page).to have_content 'Order Total: $1,075.07 (GH₵ 6,235.39)', normalize_ws: true
      expect(page).to have_content 2.weeks.from_now.to_date.to_s(:long), normalize_ws: true
    end
  end

  scenario 'should be able to remove an item from my cart' do
    login_as cart.user

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07G4MNFS1')
    click_button 'Add to Cart'

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07P8MQHSH')
    click_button 'Add to Cart'

    expect(page).to have_content 'Items in Your Cart'

    within '#cart_list' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell ' \
                                   'Phone (Unlocked) - Just Black $422.99',
                                   normalize_ws: true

      expect(page).to have_content 'Sony Noise Cancelling Headphones ' \
                                   'WH1000XM3: Wireless Bluetooth Over the ' \
                                   'Ear Headphones with Mic and Alexa voice ' \
                                   'control - Industry Leading Active Noise ' \
                                   'Cancellation - Black $278.00',
                                   normalize_ws: true
    end

    within '#costs_card' do
      expect(page).to have_content 'Order Summary'
      expect(page).to have_content 'Items (2): $700.99 ', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $106.02 ', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $284.31 ', normalize_ws: true
      expect(page).to have_content 'Order Total: $1,091.32 (GH₵ 6,329.65) ', normalize_ws: true
      expect(page).to have_content 2.weeks.from_now.to_date.to_s(:long), normalize_ws: true

      expect(page).to have_content 'Duty charges are subject to changes by ' \
                                   'customs officers on arrival Checkout',
                                   normalize_ws: true
    end

    within '#cart_list .list-group-item', match: :first do
      click_button 'Remove'
    end

    within '#costs_card' do
      expect(page).to have_content 'Items (1): $278.00', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $50.11', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $114.94', normalize_ws: true
      expect(page).to have_content 'Order Total: $443.05 (GH₵ 2,569.68)', normalize_ws: true
      expect(page).to have_content 2.weeks.from_now.to_date.to_s(:long), normalize_ws: true
    end
  end

  scenario 'should be able to click checkout and be taken to the checkout page' do
    login_as cart.user

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07G4MNFS1')
    click_button 'Add to Cart'

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07P8MQHSH')
    click_button 'Add to Cart'

    click_link 'Checkout'

    expect(page).to have_content 'Delivery Address'
    expect(page).to have_content 'Full name'
    expect(page).to have_content 'Address Eg. Total Filling Station behind the Kanda Overhead, House no. 5'
    expect(page).to have_content 'City/Town'
    expect(page).to have_content 'Region'
    expect(page).to have_content "Phone number This number should be active so we can reach you when we're delivering your item"
    expect(page).to have_content 'Order Summary'
    expect(page).to have_content 'Items (2): $700.99'
    expect(page).to have_content 'Shipping & Insurance: $106.02'
    expect(page).to have_content 'Estimated Duty: $284.31'
    expect(page).to have_content 'Order Total: $1,091.32 (GH₵ 6,329.65)'
    expect(page).to have_content 2.weeks.from_now.to_date.to_s(:long)
    expect(page).to have_content 'Duty charges are subject to changes by customs officers on arrival'
  end

  scenario 'should be able to click an item in my cart and be taken to the items product page' do
    login_as cart.user

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07G4MNFS1')
    click_button 'Add to Cart'

    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07P8MQHSH')
    click_button 'Add to Cart'

    expect(page).to have_content 'Items in Your Cart'

    within '#cart_list' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell ' \
                                   'Phone (Unlocked) - Just Black $422.99',
                                   normalize_ws: true

      expect(page).to have_content 'Sony Noise Cancelling Headphones ' \
                                   'WH1000XM3: Wireless Bluetooth Over the ' \
                                   'Ear Headphones with Mic and Alexa voice ' \
                                   'control - Industry Leading Active Noise ' \
                                   'Cancellation - Black $194.48',
                                   normalize_ws: true
    end

    click_link 'Google - Pixel 3 with 64GB Memory Cell ' \
                 'Phone (Unlocked) - Just Black $422.99', wait: 5 * 60


    within '#product_details' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell Phone (Unlocked) - Just Black'
      expect(page).to have_content 'by TTP Retail'
      expect(page).to have_content '$422.99'
      expect(page).to have_content 'Condition: New'
      expect(page).to have_content 'Positive Reviews: 97%'
      expect(page).to have_content 'Number of Reviews: 4,951'
      expect(page).to have_content 'Ships within 0 to 0 days'
      expect(page).to have_button 'Add to Cart'
    end

    within '#product_dimensions' do
      expect(page).to have_content 'Product Details'
      expect(page).to have_content 'Width: 3.90 inches', normalize_ws: true
      expect(page).to have_content 'Length: 7.10 inches', normalize_ws: true
      expect(page).to have_content 'Depth: 1.90 inches', normalize_ws: true
      expect(page).to have_content 'Weight: 1.30 pounds', normalize_ws: true
    end

    within '#other_offers' do
      expect(page).to have_content '$350.00 - Used - Like New'
      expect(page).to have_content '95% positive reviews'
      expect(page).to have_content 'infinity_plus_one'
      expect(page).to have_content '75 total reviews'
      expect(page).to have_content 'Ships within 7 to 22 days'
    end
  end
end
