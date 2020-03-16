require 'rails_helper'

RSpec.describe "carts/show", type: :view do
  before(:each) do
    skip
    @cart = assign(:cart, Cart.create!())
  end

  it "renders attributes in <p>" do
    skip
    render
  end
end
