# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @product = Product.new
  end

  def privacy_policy; end

  def terms; end

  def refund_policy; end

  def careers; end
end
