require 'rails_helper'

RSpec.describe "orders/show", type: :view do
  before(:each) do
    @order = assign(:order, Order.create!(
      :product_id => "Product",
      :user_id => "User",
      :chosen_offer_id => "Chosen Offer",
      :quantity => 2,
      :delivery_method => 3,
      :full_name => "Full Name",
      :address => "Address",
      :region => 4,
      :city_or_town => "City Or Town",
      :phone_number => "Phone Number",
      :email => "Email",
      :txtref => "Txtref",
      :status => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Product/)
    expect(rendered).to match(/User/)
    expect(rendered).to match(/Chosen Offer/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Full Name/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/City Or Town/)
    expect(rendered).to match(/Phone Number/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Txtref/)
    expect(rendered).to match(/5/)
  end
end
