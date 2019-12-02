# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Product Management', js: true do
  let!(:user) { FactoryBot.build(:user) }
  let(:product) { FactoryBot.create(:product) }
  let!(:new_product) { FactoryBot.create(:product) }
  let!(:new_order) { FactoryBot.build(:order, quantity: 1, delivery_method: :by_air) }

  xscenario 'should be able to order a product on ProcureSwift' do
    visit product_path new_product

    choose '$278.00 New', match: :first
    expect(page).to have_content 'Product was successfully updated.'

    expect(page).to have_content '$64.57'
    expect(page).to have_content '$40.96'

    click_link 'Purchase through ProcureSwift'

    click_link 'Sign up'

    fill_in :user_full_name, with: user.full_name
    fill_in :user_email, with: user.email
    fill_in :user_phone_number, with: user.phone_number
    fill_in :user_password, with: user.password

    click_button 'Sign up'

    expect(page).to have_content 'Signed in successfully.'

    click_link 'Purchase through ProcureSwift'

    expect(page).to have_content 'Order was successfully created.'

    choose('$278.00 New')
    expect(page).to have_content 'Order was successfully updated.'

    select new_order.quantity, from: :order_item_quantity
    expect(page).to have_content 'Order was successfully updated.'

    select new_order.delivery_method.titleize, from: :order_delivery_method
    expect(page).to have_content 'Order was successfully updated.'

    fill_in :order_full_name, with: new_order.full_name
    fill_in :order_address, with: new_order.phone_number
    fill_in :order_city_or_town, with: new_order.phone_number

    select new_order.region.titleize, from: :order_region

    fill_in :order_email, with: new_order.phone_number
    fill_in :order_phone, with: new_order.phone_number

    click_button "Make Payment #{number_to_currency new_order.order_total}"
  end
end
