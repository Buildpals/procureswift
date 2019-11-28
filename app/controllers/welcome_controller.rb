class WelcomeController < ApplicationController
  def index
    @order = Order.new
  end
end
