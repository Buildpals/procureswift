require 'rails_helper'

RSpec.describe "orders/new", type: :view do
  let!(:customer) { FactoryBot.create(:user) }
  before(:each) do
    skip
    assign(:order, Order.new(
      :user_id => User.first,
      :txtref => "MyString",
      :cart_id => Cart.last,
      :status => 1
    ))
  end

  it "renders order details" do
    render
    expect(rendered).to_contents match('Delivery Address')
    expect(rendered).to_contents match('Items in Your Cart')
  end
end
