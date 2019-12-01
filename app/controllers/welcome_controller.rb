class WelcomeController < ApplicationController
  def index
    @product = Product.new
  end
end
