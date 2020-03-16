# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @product = Product.new
    @recent_products = Product
                       .where.not(zinc_product_details: nil)
                       .where(featured: true)
                       .last(6)
  end

  def privacy_policy; end

  def terms; end

  def refund_policy; end

  def careers; end
end
