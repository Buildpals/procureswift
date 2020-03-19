# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_product, only: %i[show]

  # GET /products
  def index
    @products = Product.search(query = params[:query],
                               retailer = params[:retailer])
  end

  # GET /products/1
  def show
    @offer = @product.offers.find { |offer| offer.id == params[:offer_id] } ||
             @product.offers.first
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end
end
