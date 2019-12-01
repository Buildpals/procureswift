# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Product Management', js: true do
  product_url = 'https://www.amazon.com/Sony-Noise-Cancelling-Headphones-WH1000XM3/dp/B07G4MNFS1/ref=br_msw_pdt-13?_encoding=UTF8&smid=ATVPDKIKX0DER&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=&pf_rd_r=R6625NYYBDMBFYGBHEW7&pf_rd_t=36701&pf_rd_p=7e677bdf-d1ce-499a-8af2-d14952e2223b&pf_rd_i=desktop'

  scenario 'should be able to add an Amazon product to procureswift' do
    visit root_path

    fill_in :product_item_url, with: product_url

    select '1', from: :product_item_quantity
    select 'By Air', from: :product_delivery_method

    fill_in :product_full_name, with: 'Kofi Babone'
    fill_in :product_phone_number, with: '0245678910'

    click_button 'Get Shipping Cost', wait: 30

    expect(page).to have_content 'Sony Noise Cancelling Headphones WH1000XM3: Wireless Bluetooth Over the Ear Headphones with Mic and Alexa voice control - Industry Leading Active Noise Cancellation - Black'
  end
end
