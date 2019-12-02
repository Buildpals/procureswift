require 'rails_helper'

RSpec.describe "orders/new", type: :view do
  before(:each) do
    assign(:order, Order.new(
      :product_id => "MyString",
      :user_id => "MyString",
      :chosen_offer_id => "MyString",
      :quantity => 1,
      :delivery_method => 1,
      :full_name => "MyString",
      :address => "MyString",
      :region => 1,
      :city_or_town => "MyString",
      :phone_number => "MyString",
      :email => "MyString",
      :txtref => "MyString",
      :status => 1
    ))
  end

  it "renders new order form" do
    render

    assert_select "form[action=?][method=?]", orders_path, "post" do

      assert_select "input[name=?]", "order[product_id]"

      assert_select "input[name=?]", "order[user_id]"

      assert_select "input[name=?]", "order[chosen_offer_id]"

      assert_select "input[name=?]", "order[quantity]"

      assert_select "input[name=?]", "order[delivery_method]"

      assert_select "input[name=?]", "order[full_name]"

      assert_select "input[name=?]", "order[address]"

      assert_select "input[name=?]", "order[region]"

      assert_select "input[name=?]", "order[city_or_town]"

      assert_select "input[name=?]", "order[phone_number]"

      assert_select "input[name=?]", "order[email]"

      assert_select "input[name=?]", "order[txtref]"

      assert_select "input[name=?]", "order[status]"
    end
  end
end
