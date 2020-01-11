# frozen_string_literal: true

require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature 'Product Management', js: true do
  let!(:user) { FactoryBot.build(:user) }
  let(:product) { FactoryBot.create(:product) }
  let!(:new_product) { FactoryBot.build(:product) }
  let!(:new_order) { FactoryBot.build(:order, quantity: 1, delivery_method: :by_air) }

  scenario 'should be able to add an Amazon product to procureswift' do
    visit root_path

    fill_in :product_item_url, with: new_product.item_url

    fill_in :product_full_name, with: new_product.full_name
    fill_in :product_phone_number, with: new_product.phone_number

    click_button 'Get Shipping Cost', wait: 5 * 60

    expect(page).to have_content new_product.title
    expect(page).to have_content 'Product was successfully created.'

    choose '$298.00 New', match: :first
    expect(page).to have_content 'Product was successfully updated.'

    expect(page).to have_content '$50.27'

    click_link 'Purchase through ProcureSwift'

    click_link 'Sign up'

    fill_in :user_full_name, with: user.full_name
    fill_in :user_email, with: user.email
    fill_in :user_phone_number, with: user.phone_number

    fill_in :user_password, with: user.password
    fill_in :user_password_confirmation, with: user.password

    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'

    click_button 'Purchase through ProcureSwift'

    expect(page).to have_content 'Order was successfully created.'

    save_and_open_page

    choose '$298.00 New', match: :first
    expect(page).to have_content 'Order was successfully updated.'

    select new_order.quantity, from: :order_quantity
    expect(page).to have_content 'Order was successfully updated.'

    select new_order.delivery_method.titleize, from: :order_delivery_method
    expect(page).to have_content 'Order was successfully updated.'

    fill_in :order_full_name, with: new_order.full_name
    fill_in :order_address, with: new_order.phone_number
    fill_in :order_city_or_town, with: new_order.phone_number

    select new_order.region.titleize, from: :order_region

    fill_in :order_email, with: new_order.email
    fill_in :order_phone_number, with: new_order.phone_number

    click_button "Make Payment #{number_to_currency new_order.order_total}"
  end
end
