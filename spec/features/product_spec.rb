# frozen_string_literal: true

require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature 'Product Management', js: true do
  let!(:customer) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product) }
  let!(:new_product) { FactoryBot.build(:product) }
  #let!(:new_order) { FactoryBot.build(:order, quantity: 1, delivery_method: :by_air) }

  xscenario 'should be able to get a product details from Amazon' do
    visit root_path

    fill_in :product_item_url, with: new_product.item_url

    click_button 'Get Shipping Cost', wait: 5 * 60

    expect(page).to have_content new_product.title
    expect(page).to have_content 'Product Dimensions'
    expect(page).to have_content 'Width'
    expect(page).to have_content 'Length'
    expect(page).to have_content 'Depth'
    expect(page).to have_content 'Weight'
    expect(page).to have_content 'Price'
    expect(page).to have_content '7.60 inches'
    expect(page).to have_content '8.80 inches'
    expect(page).to have_content '3.00 inches'
    expect(page).to have_content '1.67 pounds'
    #expect(page).to have_content number_to_currency new_product.price
    #expect(page).to have_content number_to_currency new_product.freight_insurance_handling
    #expect(page).to have_content number_to_currency new_product.duty
  end

  xscenario 'should force user to sign in if he hasn\'t signed in before checkout' do
    visit root_path

    fill_in :product_item_url, with: new_product.item_url

    click_button 'Get Shipping Cost', wait: 5 * 60

    click_link 'Add to Cart'

    expect(page).to have_content 'Sign up'
  end

  xscenario 'should allow user to add to cart' do
    login_as customer

    visit root_path

    fill_in :product_item_url, with: new_product.item_url

    click_button 'Get Shipping Cost', wait: 5 * 60

    click_button 'Add to Cart'

    expect(page).to have_content 'Item added to cart successfully.'
  end

  xscenario 'should allow user to fill delivery details' do
    login_as customer

    visit root_path

    fill_in :product_item_url, with: new_product.item_url

    click_button 'Get Shipping Cost', wait: 5 * 60

    click_button 'Add to Cart'

    click_link 'Checkout'

    expect(page).to have_content 'This number should be active so we can reach you when we\'re delivering your item'

    expect(page).to have_content 'Delivery Address'
  end

  scenario 'should allow user to remove an item from his/her cart' do
    login_as customer

    visit root_path

    fill_in :product_item_url, with: new_product.item_url

    click_button 'Get Shipping Cost', wait: 5 * 60

    click_button 'Add to Cart'

    #number_of_cart_items = current_cart.number_of_items

    click_button 'Remove'

    expect(page).to have_content 'Item removed from cart successfully.'

    expect(customer.carts.last.cart_items.count).to eq 0
  end

  def given_a_user_has_logged_in
    login_as user, scope: :user
  end

end
