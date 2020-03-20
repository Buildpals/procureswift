# frozen_string_literal: true

require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature 'Product Management', vcr: { allow_playback_repeats: true } do
  let!(:customer) { FactoryBot.create(:user) }

  scenario 'should be able to search for a product on Amazon' do
    visit root_path

    fill_in :query, with: 'pixel 4'

    click_button :search

    expect(page).to have_content 'Showing results for pixel 4'

    expect(page).to have_content 'Google Pixel 4 XL - Clearly White - 64GB - Unlocked (Renewed)'
    expect(page).to have_content '$559.95'
    expect(page).to have_content 'Stars: 2.8'
    expect(page).to have_content 'Reviewers: 12'

    expect(page).to have_link 'ZIZO Bolt Series Google Pixel 4 Case | Heavy-Duty Military-Grade Drop Protection w/Kickstand Included Belt Clip Holster Tempered Glass Lanyard (Metal Gray/Black)'
    expect(page).to have_content '$18.99'
    expect(page).to have_content 'Stars: 4.3'
    expect(page).to have_content 'Reviewers: 47'
  end

  xscenario 'should be able to click on a product in the search results and view it\'s details' do
    visit root_path

    fill_in :query, with: 'pixel 4'

    click_button 'Search', wait: 5 * 60

    expect(page).to have_content 'Showing results for pixel 4'

    expect(page).to have_content 'Google Pixel 4 XL - Clearly White - 64GB - Unlocked (Renewed)'
    expect(page).to have_content '$559.95'
    expect(page).to have_content 'Stars: 2.8'
    expect(page).to have_content 'Reviewers: 12'

    expect(page).to have_link 'ZIZO Bolt Series Google Pixel 4 Case | Heavy-Duty Military-Grade Drop Protection w/Kickstand Included Belt Clip Holster Tempered Glass Lanyard (Metal Gray/Black)'
    expect(page).to have_content '$18.99'
    expect(page).to have_content 'Stars: 4.3'
    expect(page).to have_content 'Reviewers: 47'

    click_link 'Google Pixel 4 XL - Clearly White - 64GB - Unlocked (Renewed)'

    within '#product_details' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell Phone (Unlocked) - Just Black'
      expect(page).to have_content 'by TTP Retail'
      expect(page).to have_content '$422.99'
      expect(page).to have_content 'Condition: New'
      expect(page).to have_content 'Positive Reviews: 97%'
      expect(page).to have_content 'Number of Reviews: 4,951'
      expect(page).to have_content 'Ships within 0 to 0 days'
    end

    within '#product_dimensions' do
      expect(page).to have_content 'Product Dimensions'
      expect(page).to have_content 'Width: 3.90 inches', normalize_ws: true
      expect(page).to have_content 'Length: 7.10 inches', normalize_ws: true
      expect(page).to have_content 'Depth: 1.90 inches', normalize_ws: true
      expect(page).to have_content 'Weight: 1.30 pounds', normalize_ws: true
    end

    within '#costs_card' do
      expect(page).to have_content 'Price: $422.99', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $55.91', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $169.37', normalize_ws: true
      expect(page).to have_content 'Total: $648.27 (GH₵ 3,759.98)', normalize_ws: true
      expect(page).to have_content "Will be delivered by #{2.weeks.from_now.strftime('%A, %b.%e')} (2 weeks)", normalize_ws: true
      expect(page).to have_content 'Duty charges are subject to changes by customs.', normalize_ws: true
      expect(page).to have_link 'Add to Cart'
    end

    within '#other_offers' do
      expect(page).to have_content 'Other Offers'
      expect(page).to have_content '$422.99 - New'
      expect(page).to have_content '95% positive reviews'
      expect(page).to have_content 'USA Supply Source'
      expect(page).to have_content '13,666 total reviews'
      expect(page).to have_content 'Ships within 0 to 0 days'

      expect(page).to have_content '$350.00 - Used - Like New'
      expect(page).to have_content '95% positive reviews'
      expect(page).to have_content 'infinity_plus_one'
      expect(page).to have_content '75 total reviews'
      expect(page).to have_content 'Ships within 7 to 22 days'
    end
  end

  scenario 'should be able to view details of a particular product' do
    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07P8MQHSH')

    within '#product_details' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell Phone (Unlocked) - Just Black'
      expect(page).to have_content 'by TTP Retail'
      expect(page).to have_content '$422.99'
      expect(page).to have_content 'Condition: New'
      expect(page).to have_content 'Positive Reviews: 97%'
      expect(page).to have_content 'Number of Reviews: 4,951'
      expect(page).to have_content 'Ships within 0 to 0 days'
    end

    within '#product_dimensions' do
      expect(page).to have_content 'Product Dimensions'
      expect(page).to have_content 'Width: 3.90 inches', normalize_ws: true
      expect(page).to have_content 'Length: 7.10 inches', normalize_ws: true
      expect(page).to have_content 'Depth: 1.90 inches', normalize_ws: true
      expect(page).to have_content 'Weight: 1.30 pounds', normalize_ws: true
    end

    within '#costs_card' do
      expect(page).to have_content 'Price: $422.99', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $55.91', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $169.37', normalize_ws: true
      expect(page).to have_content 'Total: $648.27 (GH₵ 3,759.98)', normalize_ws: true
      expect(page).to have_content "Will be delivered by #{2.weeks.from_now.strftime('%A, %b.%e')} (2 weeks)", normalize_ws: true
      expect(page).to have_content 'Duty charges are subject to changes by customs.', normalize_ws: true
      expect(page).to have_link 'Add to Cart'
    end

    within '#other_offers' do
      expect(page).to have_content 'Other Offers'
      expect(page).to have_content '$422.99 - New'
      expect(page).to have_content '95% positive reviews'
      expect(page).to have_content 'USA Supply Source'
      expect(page).to have_content '13,666 total reviews'
      expect(page).to have_content 'Ships within 0 to 0 days'

      expect(page).to have_content '$350.00 - Used - Like New'
      expect(page).to have_content '95% positive reviews'
      expect(page).to have_content 'infinity_plus_one'
      expect(page).to have_content '75 total reviews'
      expect(page).to have_content 'Ships within 7 to 22 days'
    end
  end

  scenario 'should be able to select another offer for a product' do
    visit product_path Product.merge_retailer_with_product_id('amazon',
                                                              'B07P8MQHSH')

    within '#product_details' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell Phone (Unlocked) - Just Black'
      expect(page).to have_content 'by unknown'
      expect(page).to have_content '$199.97'
      expect(page).to have_content 'Condition: Used'
      expect(page).to have_content 'Positive Reviews: 94%'
      expect(page).to have_content 'Number of Reviews: 1,196'
      expect(page).to have_content 'Ships within 0 to 0 days'
    end

    within '#costs_card' do
      expect(page).to have_content 'Price: $199.97', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $46.99', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $85.64', normalize_ws: true
      expect(page).to have_content 'Total: $332.60 (GH₵ 1,929.09)', normalize_ws: true
      expect(page).to have_content "Will be delivered by #{2.weeks.from_now.strftime('%A, %b.%e')} (2 weeks)", normalize_ws: true
      expect(page).to have_content 'Duty charges are subject to changes by customs.', normalize_ws: true
      expect(page).to have_link 'Add to Cart'
    end

    within '#other_offers' do
      click_link '$241.08 - Used 79% positive reviews unknown 4,188,165 total reviews Ships within 0 to 0 days'
    end

    within '#product_details' do
      expect(page).to have_content 'Google - Pixel 3 with 64GB Memory Cell Phone (Unlocked) - Just Black'
      expect(page).to have_content 'by unknown'
      expect(page).to have_content '$241.08'
      expect(page).to have_content 'Condition: Used'
      expect(page).to have_content 'Positive Reviews: 79%'
      expect(page).to have_content 'Number of Reviews: 4,188,165'
      expect(page).to have_content 'Ships within 0 to 0 days'
    end

    # The price should change to reflect the selected offer
    within '#costs_card' do
      expect(page).to have_content 'Price: $241.08', normalize_ws: true
      expect(page).to have_content 'Shipping & Insurance: $48.63', normalize_ws: true
      expect(page).to have_content 'Estimated Duty: $101.08', normalize_ws: true
      expect(page).to have_content 'Total: $390.79 (GH₵ 2,266.58)', normalize_ws: true
      expect(page).to have_content "Will be delivered by #{2.weeks.from_now.strftime('%A, %b.%e')} (2 weeks)", normalize_ws: true
      expect(page).to have_content 'Duty charges are subject to changes by customs.', normalize_ws: true
      expect(page).to have_link 'Add to Cart'
    end

    # The original offer should now be part of the other offers
    within '#other_offers' do
      expect(page).to have_content '$199.97 - Used'
      expect(page).to have_content '94% positive reviews'
      expect(page).to have_content 'unknown'
      expect(page).to have_content '1,196 total reviews Ships'
      expect(page).to have_content 'Ships within 0 to 0 days'
    end
  end

  def given_a_user_has_logged_in
    login_as user, scope: :user
  end
end
