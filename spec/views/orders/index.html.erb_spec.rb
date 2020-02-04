require 'rails_helper'

RSpec.describe "orders/index", type: :view do
  before(:each) do
    skip
    assign(:orders, [
      Order.create!(
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
      ),
      Order.create!(
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
      )
    ])
  end

  it "renders a list of orders" do
    render
    assert_select "tr>td", :text => "Product".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Chosen Offer".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Full Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "City Or Town".to_s, :count => 2
    assert_select "tr>td", :text => "Phone Number".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Txtref".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
