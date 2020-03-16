require 'rails_helper'

RSpec.describe "carts/new", type: :view do
  before(:each) do
    skip
    assign(:cart, Cart.new())
  end

  it "renders new cart form" do
    skip
    # no cart form
  end
end
