class WelcomeController < ApplicationController
  def index
    @product = Product.new
    @products = Product.joins(:orders)
                    .where(orders: { status: :success })
                    .order(created_at: :desc)
                    .limit(6)
  end

  def privacy_policy; end

  def terms; end

end
