require 'rails_helper'

RSpec.describe "carts/index", type: :view do
  before(:each) do
    skip
    assign(:carts, [
      Cart.create!(),
      Cart.create!()
    ])
  end

  it "renders a list of carts" do
    skip
    render
  end
end
