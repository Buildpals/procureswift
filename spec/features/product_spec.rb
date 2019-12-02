# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Product Management', js: true do
  let(:product) { FactoryBot.create(:product) }
  let!(:new_product) { FactoryBot.build(:product) }

  scenario 'should be able to add an Amazon product to procureswift' do
    visit root_path

    fill_in :product_item_url, with: new_product.item_url

    select new_product.item_quantity, from: :product_item_quantity
    select new_product.delivery_method.titleize, from: :product_delivery_method

    fill_in :product_full_name, with: new_product.full_name
    fill_in :product_phone_number, with: new_product.phone_number

    click_button 'Get Shipping Cost', wait: 30

    expect(page).to have_content new_product.title
    expect(page).to have_content 'Product was successfully created.'
  end
end
